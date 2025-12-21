use crate::{Model::*, Texture::*};
use tobj;

// Main loader for OBJ models
pub async fn load_model(
    path: &str,
    device: &wgpu::Device,
    queue: &wgpu::Queue,
) -> anyhow::Result<Model> {
    let (models, _) = tobj::load_obj(path, &tobj::LoadOptions {
        triangulate: true,
        single_index: true,
        ..Default::default()
    })?;

    let mut meshes = Vec::new();

    for m in models {
        let vertices: Vec<ModelVertex> = (0..m.mesh.positions.len() / 3)
            .map(|i| ModelVertex {
                position: [
                    m.mesh.positions[i * 3],
                    m.mesh.positions[i * 3 + 1],
                    m.mesh.positions[i * 3 + 2],
                ],
                tex_coords: if !m.mesh.texcoords.is_empty() {
                    [m.mesh.texcoords[i * 2], 1.0 - m.mesh.texcoords[i * 2 + 1]]
                } else {
                    [0.0, 0.0]
                },
                normal: if !m.mesh.normals.is_empty() {
                    [
                        m.mesh.normals[i * 3],
                        m.mesh.normals[i * 3 + 1],
                        m.mesh.normals[i * 3 + 2],
                    ]
                } else {
                    [0.0, 1.0, 0.0]
                },
            })
            .collect();

        let vertex_buffer = device.create_buffer_init(&wgpu::util::BufferInitDescriptor {
            label: Some("Vertex Buffer"),
            contents: bytemuck::cast_slice(&vertices),
            usage: wgpu::BufferUsages::VERTEX,
        });

        let index_buffer = device.create_buffer_init(&wgpu::util::BufferInitDescriptor {
            label: Some("Index Buffer"),
            contents: bytemuck::cast_slice(&m.mesh.indices),
            usage: wgpu::BufferUsages::INDEX,
        });

        meshes.push(Mesh {
            vertex_buffer,
            index_buffer,
            num_indices: m.mesh.indices.len() as u32,
        });
    }

    Ok(Model { meshes })
}
