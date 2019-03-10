import bpy
from mathutils import *
import json
import math

Epsilon = 0.00001
PositiveInfinity = float('inf')
NegativeInfinity = -PositiveInfinity
CoordinateTransform = Matrix.Rotation(math.pi*-0.5, 3, 'X')
CoordinateTransform4 = Matrix.Rotation(math.pi*-0.5, 4, 'X')

#CoordinateTransform = Matrix.Identity(3)
#CoordinateTransform4 = Matrix.Identity(4)

objectExportOrder = {'ARMATURE': 0, 'MESH' : 1}
def getObjectExportOrder(object):
    return objectExportOrder.get(object.type, 2)

def convertCoordinate(vector):
    return CoordinateTransform*vector

def convertTexcoord(tc):
    return Vector((tc.x, 1.0 - tc.y))

def convertVertexWeights(groups, groupWeights):
    if len(groupWeights) == 0:
        return (0, 0, 0, 0), (1.0, 0.0, 0.0, 0.0);
    
    indices = [0, 0, 0, 0]
    weights = [1.0, 0, 0, 0]
    for i in range(min(len(groupWeights), 4)):
        indices[i] = groups[groupWeights[i].group].bone
        weights[i] = groupWeights[i].weight
        
    s = sum(weights)
    for i in range(4):
        weights[i] = weights[i] / s
    return tuple(indices), tuple(weights)

def optionalConvertVertexWeights(doConversion, groups, groupWeights):
    if doConversion:
        return convertVertexWeights(groups, groupWeights)
    else:
        return (0, 0, 0, 0), (1.0, 0.0, 0.0, 0.0);
        
def v3Hash(v3):
    return hash(v3[0]) ^ hash(v3[1]) ^ hash(v3[2])

def v2Hash(v2):
    return hash(v2[0]) ^ hash(v2[1])

def encodeColor(color):
    return [color.r, color.g, color.b]

def encodeV3(v3):
    return [v3.x, v3.y, v3.z]

def encodeOrientation(orientation):
    quat = orientation.to_quaternion()
    return [quat.w, quat.x, quat.y, quat.z]

def closeTo(a, b):
    d = a - b
    return -Epsilon <= d and d <= Epsilon

def closeToV4(a, b):
    return closeTo(a.x, b.x) and closeTo(a.y, b.y) and closeTo(a.z, b.z) and closeTo(a.w, b.w)

def closeToV3(a, b):
    return closeTo(a.x, b.x) and closeTo(a.y, b.y) and closeTo(a.z, b.z)

def closeToV2(a, b):
    return closeTo(a.x, b.x) and closeTo(a.y, b.y)

def closeToList(a, b):
    if len(a) != len(b):
        return False
    for i in range(len(a)):
        if not closeTo(a[i], b[i]):
            return False
    return True

def closeToMatrix(a, b):
    if len(a) != len(b):
        return False
    for i in range(len(a)):
        if not closeToV4(a[i], b[i]):
            return False
    return True

class Bone:
    def __init__(self, index, parent, name, position, orientation):
        self.index = index
        self.parent = parent
        self.name = name
        self.position = position
        self.orientation = orientation
        self.children = []

class Action:
    def __init__(self, name):
        self.name = name
        self.bones = []

class PoseBoneKeyFrame:
    def __init__(self, frame, rotation, translation):
        self.frame = frame
        self.rotation = rotation
        self.translation = translation

class PoseBone:
    def __init__(self, poseBone):
        self.poseBone = poseBone
        self.keyframes = []
        self.hasChanges = False

    def addCurrentPose(self, frame):
        parentInverseMatrix = Matrix.Identity(4)
        if self.poseBone.parent is not None:
            parentInverseMatrix = self.poseBone.parent.matrix.inverted()
            
        localMatrix = parentInverseMatrix * self.poseBone.matrix
        if not self.hasChanges:
            parentRestInverseMatrix = Matrix.Identity(4)
            if self.poseBone.bone.parent is not None:
                parentRestInverseMatrix = self.poseBone.bone.parent.matrix_local.inverted()
            restLocalMatrix = parentRestInverseMatrix * self.poseBone.bone.matrix_local
            self.hasChanges = not closeToMatrix(localMatrix, restLocalMatrix)
        
        rotation = localMatrix.to_quaternion()
        translation = localMatrix.to_translation()
        self.keyframes.append(PoseBoneKeyFrame(frame, rotation, translation))
    
class VertexGroup:
    def __init__(self, name, index, bone = None):
        self.name = name
        self.index = index
        self.bone = bone

class Material:
    def __init__(self, blenderMaterial):
        self.blenderMaterial = blenderMaterial
        if blenderMaterial is None:
            self.defaultMaterial()
        else:
            self.loadBlenderMaterial(blenderMaterial)

    def defaultMaterial(self):
        self.name = 'ExporterDefaultMaterial'
        self.diffuseColor = Color((0.8, 0.8, 0.8))
        self.diffuseIntensity = 1.0
        self.specularColor = Color((0.8, 0.8, 0.8))
        self.specularIntensity = 1.0
        self.shininess = 80
        
    def loadBlenderMaterial(self, bmat):
        self.name = bmat.name
        self.diffuseColor = bmat.diffuse_color
        self.diffuseIntensity = bmat.diffuse_intensity
        self.specularColor = bmat.specular_color
        self.specularIntensity = bmat.specular_intensity
        self.shininess = bmat.specular_hardness
        
class Vertex:
    def __init__(self, position, normal, texcoords, indices = (0, 0, 0, 0),  weights = (1.0, 0.0, 0.0, 0.0)):
        self.position = position
        self.normal = normal
        self.texcoords = texcoords
        self.indices = indices
        self.weights = weights
        
    def __hash__(self):
        return v3Hash(self.position) ^ v3Hash(self.normal) ^ v2Hash(self.texcoords) ^ hash(self.indices) ^ hash(self.weights)
    
    def __eq__(self, o):
        return self.position == o.position and self.normal == o.normal and self.texcoords == o.texcoords and self.indices == o.indices and self.weights == o.weights
    
    #def closeTo(self, o):
    #    return closeToV3(self.position, o.position) and closeToV3(self.normal, o.normal) and closeToV2(self.texcoords, o.texcoords) and closeToList(self.weights, o.weights)

class Triangle:
    def __init__(self, i1, i2, i3):
        self.i1 = i1
        self.i2 = i2
        self.i3 = i3

class SubMesh:
    def __init__(self, material):
        self.triangles = []
        self.material = material
                
class WodenExporter:
    def __init__(self):
        self.vertices = []
        self.vertexDictionary = {}
        self.subMeshes = {}
        self.materials = {}
        self.canMakeTBN = True
        self.boneDictionary = {}
        self.bones = [Bone(0, None, '_exporter_root', Vector((0.0, 0.0, 0.0)), CoordinateTransform)]
        self.boneDictionary['_exporter_root'] = self.bones[0]
        self.hasArmature = False
        self.vertexGroupDictionary = {}
        self.vertexGroups = []
        self.armatures = []
        self.actions = []

    def sortBone(self, bone):
        if bone.index < 0:
            bone.index = len(self.bones)
            self.bones.append(bone)
            
        for child in bone.children:
            self.sortBone(child)

    def addBone(self, bbone):
        parentName = None
        if bbone.parent is not None:
            parentName = bbone.parent.name
            
        parentRestInverseMatrix = Matrix.Identity(4)
        if bbone.parent is not None:
            parentRestInverseMatrix = bbone.parent.matrix_local.inverted()
        restLocalMatrix = parentRestInverseMatrix * bbone.matrix_local
        translation = restLocalMatrix.to_translation()
        rotation = restLocalMatrix.to_3x3()
        
        parent = self.boneDictionary.get(parentName, self.bones[0])
        bone = Bone(-1, parent, bbone.name, translation, rotation)
        self.boneDictionary[bone.name] = bone
        parent.children.append(bone)
        
    def addArmature(self, armature, armatureObject):
        self.hasArmature = True
        for bone in armature.bones:
            self.addBone(bone)
        self.armatures.append(armatureObject)
        self.sortBone(self.bones[0])

    def addVertexGroup(self, vgroup):
        group = self.vertexGroupDictionary.get(vgroup, None)
        if group is not None:
            return group
        
        bone = self.boneDictionary.get(vgroup.name, None)
        boneIndex = -1
        if bone is not None:
            boneIndex = bone.index

        group = VertexGroup(vgroup.name, len(self.vertexGroups), boneIndex)
        self.vertexGroupDictionary[group.name] = group
        self.vertexGroups.append(group)
        return group        
    
    def addObject(self, object):
        if object.type != 'MESH': return

        # Add the armature.
        armature = None
        for modifier in object.modifiers:
            if modifier.type == 'ARMATURE' and modifier.use_vertex_groups:
                armature = modifier.object
                self.addArmature(armature.data, armature)

        # Add the vertex groups.
        vgroups = list(map(self.addVertexGroup, object.vertex_groups))
    
        # Add the mesh
        scene = bpy.context.scene
        mesh = object.to_mesh(scene, True, 'PREVIEW')
        try:
            self.addMesh(mesh, vgroups)
        finally:
            bpy.data.meshes.remove(mesh)
        
    def addMesh(self, mesh, vgroups):
        vertices = mesh.vertices
        materials = mesh.materials
        uvLayer = mesh.tessface_uv_textures.active
        if uvLayer is None:
            self.canMakeTBN = False
        
        # Add the faces
        for face in mesh.tessfaces:
            matIndex = face.material_index
            material = None
            if matIndex < len(materials):
                material = materials[matIndex]
                
            n1 = n2 = n3 = n4 = convertCoordinate(face.normal)
            v1 = vertices[face.vertices[0]]
            v2 = vertices[face.vertices[1]]
            v3 = vertices[face.vertices[2]]
            vi1, vw1 = optionalConvertVertexWeights(self.hasArmature, vgroups, v1.groups)
            vi2, vw2 = optionalConvertVertexWeights(self.hasArmature, vgroups, v2.groups)
            vi3, vw3 = optionalConvertVertexWeights(self.hasArmature, vgroups, v3.groups)
            tc1 = tc2 = tc3 = tc4 = Vector((0, 0))

            if uvLayer is not None:
                uvFace = uvLayer.data[face.index]
                tc1 = convertTexcoord(uvFace.uv1)
                tc2 = convertTexcoord(uvFace.uv2)
                tc3 = convertTexcoord(uvFace.uv3)

            # Quad            
            if len(face.vertices) > 3:
                v4 = vertices[face.vertices[3]]
                vi4, vw4 = optionalConvertVertexWeights(self.hasArmature, vgroups, v4.groups)
                if uvLayer is not None:
                    tc4 = convertTexcoord(uvFace.uv4)

            # Per vertex normal                
            if face.use_smooth:
                n1 = convertCoordinate(v1.normal)
                n2 = convertCoordinate(v2.normal)
                n3 = convertCoordinate(v3.normal)
                if len(face.vertices) > 3:
                    n4 = convertCoordinate(v4.normal)
                    
            # Add the vertices
            ev1 = self.addVertex(convertCoordinate(v1.co), n1, tc1, vi1, vw1)
            ev2 = self.addVertex(convertCoordinate(v2.co), n2, tc2, vi2, vw2)
            ev3 = self.addVertex(convertCoordinate(v3.co), n3, tc3, vi3, vw3)
            if len(face.vertices) > 3:
                ev4 = self.addVertex(convertCoordinate(v4.co), n4, tc4, vi4, vw4)
                
            # Add the triangles
            if len(face.vertices) > 3:
                self.addTriangle(material, ev1.index, ev2.index, ev3.index)
                self.addTriangle(material, ev3.index, ev4.index, ev1.index)
            else:
                self.addTriangle(material, ev1.index, ev2.index, ev3.index)
    
    def computeBoundingBox(self):
        minX, minY, minZ = PositiveInfinity, PositiveInfinity, PositiveInfinity
        maxX, maxY, maxZ = NegativeInfinity, NegativeInfinity, NegativeInfinity
        for v in self.vertices:
            p = v.position
            minX = min(minX, p.x)
            minY = min(minY, p.y)
            minZ = min(minZ, p.z)
            maxX = max(maxX, p.x)
            maxY = max(maxY, p.y)
            maxZ = max(maxZ, p.z)
        self.boundingBox = [minX, minY, minZ, maxX, maxY, maxZ]
            
    def addVertex(self, position, normal, texcoord, boneIndices, boneWeights):
        vertex = Vertex(position, normal, texcoord, boneIndices, boneWeights)
        oldVertex = self.vertexDictionary.get(vertex, None)
        if oldVertex is not None:
            return oldVertex
            
        vertex.index = len(self.vertices)
        self.vertexDictionary[vertex] = vertex
        self.vertices.append(vertex)
        return vertex
    
    def addTriangle(self, material, i1, i2, i3):
        submesh = self.subMeshForMaterial(material)
        triangle = Triangle(i1, i2, i3)
        submesh.triangles.append(triangle)
        
    def addMaterial(self, material):
        exportMaterial = self.materials.get(material, None)
        if exportMaterial is not None:
            return exportMaterial
        
        exportMaterial = Material(material)
        self.materials[material] = exportMaterial
        return exportMaterial
    
    def addActions(self):
        for action in bpy.data.actions:
            self.addAction(action)
            
    def addAction(self, action):
        if len(action.fcurves) == 0:
            return
        frameRange = action.frame_range
        start = int(frameRange[0])
        end = int(frameRange[1])
        convertedAction = Action(action.name)
        for armature in self.armatures:
            self.addArmatureAction(action, convertedAction, armature, start, end)
        self.actions.append(convertedAction)
            
    def addArmatureAction(self, action, convertedAction, armature, start, end):
        if armature.animation_data is None:
            return
        
        armature.animation_data.action = action
        actionBones = list(map(lambda x: PoseBone(x), armature.pose.bones))
        for frame in range(start, end):
            bpy.context.scene.frame_set(frame)
            for actionBone in actionBones:
                actionBone.addCurrentPose(frame)
                
        convertedAction.bones += filter(lambda b: b.hasChanges, actionBones)
           
    def subMeshForMaterial(self, material):
        exportMaterial = self.addMaterial(material)
        submesh = self.subMeshes.get(exportMaterial, None)
        if submesh is not None:
            return submesh
        
        submesh = SubMesh(exportMaterial)
        self.subMeshes[exportMaterial] = submesh
        return submesh
    
    def encodeMaterial(self, material):
        self.diffuseColor = (0.8, 0.8, 0.8)
        self.diffuseIntensity = 1.0
        self.specularColor = (0.8, 0.8, 0.8)
        self.specularIntensity = 1.0
        self.shininess = 80
        return {
            'diffuseColor' : encodeColor(material.diffuseColor),
            'diffuseIntensity' : material.diffuseIntensity,
            'specularColor' : encodeColor(material.specularColor),
            'specularIntensity' : material.specularIntensity,
            'shininess' : material.shininess,
            }
        
    def encodeMaterials(self):
        materials = {}
        for material in self.materials.values():
            materials[material.name] = self.encodeMaterial(material)
        return materials
    
    def encodeVertices(self):
        positions = []
        normals = []
        texcoords = []
        tangents = []
        boneIndices = []
        boneWeights = []
        
        for v in self.vertices:
            # Position
            p = v.position
            positions.append(p.x)
            positions.append(p.y)
            positions.append(p.z)
            
            # Normal
            n = v.normal
            normals.append(n.x)
            normals.append(n.y)
            normals.append(n.z)
            
            # Texcoords
            tc = v.texcoords
            texcoords.append(tc.x)
            texcoords.append(tc.y)
            
            if self.canMakeTBN:
                t = v.tangent
                tangents.append(t.x)
                tangents.append(t.y)
                tangents.append(t.z)
                tangents.append(n.cross(t).dot(v.bitangent))
        
            if self.hasArmature:
                # Bone indices
                bindices = v.indices
                bweights = v.weights

                for i in range(len(bindices)):
                    boneIndices.append(bindices[i])
                    boneWeights.append(bweights[i])
                
        result = {
            'positions' : positions,
            'normals' : normals,
            'texcoords' : texcoords
        }
        
        if self.canMakeTBN:
            result['tangents4'] = tangents

        if self.hasArmature:
            result['boneIndices'] = boneIndices
            result['boneWeights'] = boneWeights

        return result
    
    def encodeTriangles(self, triangles):
        indices = []
        for t in triangles:
            indices.append(t.i1)
            indices.append(t.i2)
            indices.append(t.i3)
        return indices
    
    def encodeSubMesh(self, subMesh):
        triangles = self.encodeTriangles(subMesh.triangles)
        return {'material': subMesh.material.name , 'triangles' : triangles }
    
    def encodeSubMeshes(self):
        submeshes = []
        for submesh in self.subMeshes.values():
            submeshes.append(self.encodeSubMesh(submesh))
        return submeshes

    def encodeBone(self, bone):
        parentIndex = -1
        if bone.parent is not None:
            parentIndex = bone.parent.index
        return {'name': bone.name, 'parent': parentIndex,'location' : encodeV3(bone.position), 'orientation': encodeOrientation(bone.orientation)}
        
    def encodeArmature(self):
        bones = []
        for bone in self.bones:
            bones.append(self.encodeBone(bone))
            
        return bones
    
    def encodePoseBoneKeyFrame(self, kf):
        return {
            'frame' : kf.frame - 1,
            'rotation' : list(kf.rotation),
            'translation' : list(kf.translation),
        }
    
    def encodePoseBone(self, bone):
        return {
            'index' : self.boneDictionary[bone.poseBone.name].index,
            'keyframes' : list(map(lambda kf: self.encodePoseBoneKeyFrame(kf), bone.keyframes))
        }
   
    def encodeAction(self, action):
        action = {
            'name' : action.name,
            'bones' : list(map(lambda b: self.encodePoseBone(b), action.bones))
        }
        return action
    
    def encodeActions(self):
        actions = []
        for action in self.actions:
            actions.append(self.encodeAction(action))
        return actions
    
    def makeJsonData(self):
        self.jsonData = {
            'materials' : self.encodeMaterials(),
            'vertices' : self.encodeVertices(),
            'submeshes' : self.encodeSubMeshes(),
            'boundingBox' : self.boundingBox
        }
        
        if self.hasArmature:
            self.jsonData['armature'] = self.encodeArmature()
            self.jsonData['actions'] = self.encodeActions()
                
    def writeToFile(self, filepath, prettyPrint):
         with open(filepath, 'w', encoding='utf-8') as f:
             if prettyPrint:
                 f.write(json.dumps(self.jsonData, sort_keys=True, indent=4))
             else:
                 f.write(json.dumps(self.jsonData))
                 
    def buildTBN(self):
        if not self.canMakeTBN: return
    
        # Reset the tangents and bitangents
        for v in self.vertices:
            v.normal = Vector((0.0, 0.0, 0.0))
            v.tangent = Vector((0.0, 0.0, 0.0))
            v.bitangent = Vector((0.0, 0.0, 0.0))
            
        # Compute the contributions per triangle
        for sm in self.subMeshes.values():
            for t in sm.triangles:
                a = self.vertices[t.i1]
                b = self.vertices[t.i2]
                c = self.vertices[t.i3]

                u = b.position - a.position
                v = c.position - a.position
                n = u.cross(v)
                		
                tu = b.texcoords - a.texcoords
                tv = c.texcoords - a.texcoords
                		
                factors = Matrix((tu, tv))
                factors.invert()
                T = factors[0][0]*u + factors[0][1]*v;
                B = factors[1][0]*u + factors[1][1]*v;
                		
                a.normal += n
                b.normal += n
                c.normal += n
                a.tangent += T
                b.tangent += T
                c.tangent += T
                a.bitangent += B
                b.bitangent += B
                c.bitangent += B
                
        # Normalize and Gramm-Schmidt orthogonalization
        for v in self.vertices:
            # Normalize the normal
            v.normal.normalize()
            
            # Gram-Schmidth orthgonalization.
            v.tangent = (v.tangent - v.normal.dot(v.tangent)*v.normal).normalized()
            v.bitangent = (v.bitangent - v.normal.dot(v.bitangent)*v.normal - v.tangent.dot(v.bitangent)*v.tangent).normalized()
            
def export_woden_json(context, filepath, exportSelected, prettyPrint):
    exporter = WodenExporter()
    
    if exportSelected:
        objectList = list(context.selected_objects)
    else:
        objectList = list(context.scene.objects)

    for obj in objectList:
        if obj.type == 'ARMATURE':
            obj.data.pose_position = 'REST'
    context.scene.update()

    objectList.sort(key=getObjectExportOrder)
    print(objectList)
    for obj in objectList:
        exporter.addObject(obj)

    if exporter.hasArmature:
        for obj in objectList:
            if obj.type == 'ARMATURE':
                obj.data.pose_position = 'POSE'
        context.scene.update()
        exporter.addActions()
        
    exporter.computeBoundingBox()
    exporter.buildTBN()
    exporter.makeJsonData()
    exporter.writeToFile(filepath, prettyPrint)
    return {'FINISHED'}


# ExportHelper is a helper class, defines filename and
# invoke() function which calls the file selector.
from bpy_extras.io_utils import ExportHelper
from bpy.props import StringProperty, BoolProperty, EnumProperty
from bpy.types import Operator


class WodenExporterOperator(Operator, ExportHelper):
    """This appears in the tooltip of the operator and in the generated docs"""
    bl_idname = "woden.jsonexporter"  # important since its how bpy.ops.import_test.some_data is constructed
    bl_label = "Export Woden JSON"

    # ExportHelper mixin class uses this
    filename_ext = ".wmjson"

    filter_glob = StringProperty(
            default="*.wmjson",
            options={'HIDDEN'},
            )

    # List of operator properties, the attributes will be assigned
    # to the class instance from the operator settings before calling.
    export_selected = BoolProperty(
            name="Export Selected",
            description="Export the selected objects",
            default=True,
            )

    pretty_print = BoolProperty(
            name="Pretty Printing",
            description="Prettify the export json file",
            default=False,
            )

    def execute(self, context):
        return export_woden_json(context, self.filepath, self.export_selected, self.pretty_print)

# Only needed if you want to add into a dynamic menu
def menu_func_export(self, context):
    self.layout.operator(WodenExporterOperator.bl_idname, text="Export Woden JSON")

def register():
    bpy.utils.register_class(WodenExporterOperator)
    bpy.types.INFO_MT_file_export.append(menu_func_export)


def unregister():
    bpy.utils.unregister_class(WodenExporterOperator)
    bpy.types.INFO_MT_file_export.remove(menu_func_export)


if __name__ == "__main__":
    register()

    # test call
    bpy.ops.woden.jsonexporter('INVOKE_DEFAULT')
