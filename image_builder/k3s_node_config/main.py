import yaml
from jinja2 import Template

TEMPLATE_FILE = 'rpi_template.yaml'


def config(config_file: str):
    with open(config_file) as f:
        return yaml.safe_load(f.read())


def generate_config(
        control_node: str,
        node_dict: dict,
        template_file: str):
    with open(template_file) as tf:
        template = Template(tf.read())
    for k in node_dict:
        print(f"node = {k}")
        node_name = k['name']
        with open(f"{node_name}_config.yaml", "w") as f:
            f.write(
                    template.render(
                      node_name=node_name,
                      control_node=control_node,
                      labels=k.get('labels'),
                      taints=k.get('taints')))


if __name__ == "__main__":
    config = config('gen_config.yaml')
    control_node = config['k3os']['control_node']
    node_dict = config['k3os']['worker_nodes']
    generate_config(
        control_node,
        node_dict,
        TEMPLATE_FILE)
