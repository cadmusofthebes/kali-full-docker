# Pull latest docker kali image
FROM kalilinux/kali-rolling:latest

# Set variable to make this all non-interactive (no prompts)
ARG DEBIAN_FRONTEND=noninteractive

# Run all system updates and installs
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt install -y wget kali-linux-headless dbus-x11

# Setup a kali user with the password of kali
RUN useradd -m -p "saHz2oQLytbl2" "kali"
RUN usermod -a -G sudo kali

# Setup zsh
RUN chsh -s $(which zsh)
# OMZ does not seem to like Docker containers. Keep this line disabled until I figure it out
#RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Exploit Development tools
RUN apt install -y gcc-multilib python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential gdb git foremost default-jdk vim-gui-common elfutils patchelf
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade pwntools
RUN git clone https://github.com/longld/peda.git ~/peda
RUN echo "source ~/peda/peda.py" >> ~/.gdbinit
RUN echo "export LC_CTYPE=C.UTF-8" >> ~/.zshrc
RUN echo "export LC_CTYPE=C.UTF-8" >> ~/.bashrc

# Setup my vimrc
RUN curl https://raw.githubusercontent.com/cadmusofthebes/bash/main/vimrc -o ~/.vimrc

# Setup tmux
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN echo 'alias tmux="TERM=screen-256color-bce tmux"' >> ~/.zshrc
RUN echo 'alias tmux="TERM=screen-256color-bce tmux"' >> ~/.bashrc
RUN curl https://raw.githubusercontent.com/cadmusofthebes/bash/main/tmux.conf -o ~/.tmux.conf
RUN echo 'set -g default-terminal "screen-256color"' >> ~/.tmux.conf

# Setup xrdp
RUN apt-get install -y kali-desktop-xfce xorg xrdp
RUN sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini
RUN /etc/init.d/xrdp start
RUN update-rc.d xrdp defaults

# Cleanup everything
RUN apt-get -qy autoremove
CMD ["/bin/zsh"]
