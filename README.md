# advanced encryption standard (AES)
Step by step guide to set up the testing environment in Ubuntu 2022 for the AES encription and decription algorithm implemented in two-process coding style.

# Docker for GHDL
With docker already set up in your machine pull the following docker.

``bash
docker pull ghdl/ghdl:6.0.0-dev-llvm-ubuntu-22.04


# Set up a python virtual environment
Create a virtual environment, we will use it to install cocotb.

´´bash
python3 -m venv aes-venv

Activate the virtual environment.

´´bash
. aes-venv/bin/activate

Upgrade pip.

´´bash
pip install --upgrade pip

Install the required python packages in the virtual environment.

´´bash
python3 -m pip install -r pip_requirements.txt

Deactivate the virtual environment with

´´bash
deactivate


# Run the tests

Modify the python file if needed.

´´bash
cd Tests
make
