import os
import subprocess

nvidia_path = r"C:\Program Files\NVIDIA Corporation\NVIDIA App\CEF"

if not os.path.exists(nvidia_path):
    print(f"Path does not exist: {nvidia_path}")
    exit()

for root, dirs, files in os.walk(nvidia_path):
    for file in files:
        if file.lower().endswith(".exe"):
            exe_path = os.path.join(root, file)
            rule_name = f"Block_NVIDIA_{os.path.splitext(file)[0]}"
            cmd = (
                f'New-NetFirewallRule -DisplayName "{rule_name}" '
                f'-Direction Outbound -Program "{exe_path}" '
                f'-Action Block -Profile Domain,Private,Public -Enabled True'
            )
            subprocess.run(["powershell", "-Command", cmd], capture_output=True, text=True)
            print(f"Rule created: {rule_name}")

print("du nigger.")
