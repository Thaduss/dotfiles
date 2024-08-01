import os
import subprocess
import importlib.util
from pathlib import Path

#TODO:
#check for symlink DONE
#check for dir & create dir if false DONE
#auto install programs and dependenies:
# - nvim rp
# - zsh 
# - tmux plugmanager



def check_direcrory(file_path):
    # Put path in p (path.lib)
    p = Path(file_path)
    dir_path = p.parent

    current_path = Path()
    
    for part in dir_path.parts:
        current_path /= part
        if not current_path.is_dir():
            os.makedirs(current_path, exits_ok=False)
            return False
    print("dirs OK")
    return True


def load_config_from_py(config_path):
    """Load configuration from a Python file."""
    spec = importlib.util.spec_from_file_location("config", config_path)
    config_module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(config_module)
    return getattr(config_module, 'config', None)

def create_symbolic_links(dotfile_path):
    for subdir in os.listdir(dotfile_path):
        # Skip '.' and '..'
        if subdir not in ('.', '..'):
            # Make config path
            config_file_path = os.path.join(dotfile_path, subdir, 'config.py')
            

            # Check if config_path is a file
            if os.path.isfile(config_file_path):
                # Load the configuration from the Python file
                config = load_config_from_py(config_file_path)
                

                #Create symlink with linkPath, fileName 
                if config and 'linkPath' in config and 'fileName' in config:
                    file_name_path = os.path.expanduser(os.path.join(dotfile_path, subdir, config['fileName']))
                    link_path = os.path.expanduser(config['linkPath'])
                     
                    if os.path.isfile(file_name_path) and not os.path.isfile(link_path):
                        # Execute the command
                        check_direcrory(file_name_path)    
                        ln_command = f"ln -s {file_name_path} {link_path}"
                        result = subprocess.run(ln_command, shell=True)
                        
                        # Check the result
                        if result.returncode == 0:
                            print(f"Symbolic link created successfully: {config['fileName']}")
                            return True
                        else:
                            print("Failed to create symbolic link.")
                            return False
                    else:
                        if os.path.islink(link_path):
                            print(f"link exists on: {file_name_path}")
                        else:
                            print(f"Incorrect config on: {subdir}")
    
    return False



#def autoInstall
    # config.install install with sudo apt 
    # config.git install from git



if __name__ == "__main__":
    dotfile_path = os.path.expanduser("~/dotfiles")
    create_symbolic_links(dotfile_path)

    #f"ln -s ~/dotfiles/nvim/lua ~/.config/nvim"

