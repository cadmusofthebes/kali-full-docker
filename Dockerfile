# Pull latest docker kali image
FROM kalilinux/kali-rolling:latest

# Set variable to make this all non-interactive (no prompts)
ARG DEBIAN_FRONTEND=noninteractive

# Run all system updates and installs
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt install -y wget kali-linux-headless

# Setup a kali user with the password of kali
RUN useradd -m -p "saHz2oQLytbl2" "kali"
RUN usermod -a -G sudo kali

# Install CTF tools
RUN apt install -y gcc-multilib python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential gdb
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade pwntools
RUN bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
RUN echo source ~/.gdbinit-gef.py >> ~/.gdbinit
RUN echo "export LC_CTYPE=C.UTF-8" >> ~/.bashrc

# Setup my vimrc
RUN curl https://raw.githubusercontent.com/cadmusofthebes/bash/main/vimrc -o ~/.vimrc

# Setup xrdp
RUN apt-get install -y kali-desktop-xfce xorg xrdp
RUN sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini
RUN /etc/init.d/xrdp start
RUN update-rc.d xrdp defaults

# Cleanup everything
RUN apt-get -qy autoremove
CMD ["bash"]
