import random

def select_random_geometries(filename, num_geometries=1000, geometry_size=5):
    with open(filename, 'r') as file:
        lines = file.readlines()

    num_total_geometries = len(lines) // geometry_size
    if num_geometries > num_total_geometries:
        raise ValueError(f"File only contains {num_total_geometries} geometries, but {num_geometries} were requested.")

    selected_geometries = random.sample(range(num_total_geometries), num_geometries)

    selected_lines = []
    for geometry in selected_geometries:
        start = geometry * geometry_size
        end = start + geometry_size
        selected_lines.extend(lines[start:end])

    return selected_lines

def write_selected_geometries(filename, lines):
    with open(filename, 'w') as file:
        file.writelines(lines)

selected_lines = select_random_geometries('geometries_full_1000.xyz')
write_selected_geometries('geoms_1000rand_1000k.xyz', selected_lines)