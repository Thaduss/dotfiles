import os
import subprocess
import importlib.util
from pathlib import Path

def link_lua():
    lua_link_path = os.path.expanduser("~/.config/nvim/lua")
    init_path = os.path.expanduser("~/.config/nvim/init.lua")
    lua_path = os.path.expanduser("~/dotfiles/nvim/lua")
    if os.path.islink(init_path):
        if os.path.islink(lua_link_path):
            print(f"\033[35mLink exists on: {lua_link_path}\033[0m")
        else: 
            os.symlink(lua_path, lua_link_path)
            print("\033[38;5;208mSymbolic link created successfully: lua\033[0m")



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
                            print(f"\033[38;5;208mSymbolic link created successfully: {config['fileName']}\033[0m")
                            return True
                        else:
                            print("\033[31mFailed to create symbolic link.\033[0m")
                            return False
                    else:
                        if os.path.islink(link_path):
                            print(f"\033[35mlink exists on: {link_path}\033[0m")
                        else:
                            print(f"\033[31mIncorrect config on: {subdir}\033[0m")

    return False



#def autoInstall
    # config.install install with sudo apt 
    # config.git install from git



if __name__ == "__main__":
    dotfile_path = os.path.expanduser("~/dotfiles")
    create_symbolic_links(dotfile_path)
    link_lua()

