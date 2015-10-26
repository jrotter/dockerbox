# Dockerfile for installing QA development server

# Select ubuntu as the base image
FROM ubuntu

# Update ubuntu
RUN apt-get update

# Install LXDE and VNC server
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  lxde-core \
  lxterminal \
  tightvncserver

# Install vim
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  vim 

# Install rvm dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl \
  git

# Additional packages for rvm
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  gawk \
  g++ \
  gcc \
  make \
  libsqlite3-dev \
  sqlite3 \
  autoconf \
  automake \
  libreadline6-dev \
  zlib1g-dev \
  libssl-dev \
  libyaml-dev \
  libgdbm-dev \
  libncurses5-dev \
  libtool \
  bison \
  pkg-config \
  libffi-dev

# Install browsers
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
#  firefox

# Install firefox
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget
RUN wget https://ftp.mozilla.org/pub/firefox/releases/31.8.0esr/linux-x86_64/en-US/firefox-31.8.0esr.tar.bz2
RUN tar -xvjf firefox-31.8.0esr.tar.bz2 -C /opt
#sudo mv /usr/bin/firefox /usr/bin/firefox-old
RUN ln -s /opt/firefox/firefox /usr/bin/firefox

# Install packages for scripting
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  expect

# Install utilities 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  dos2unix \
  tree \
  man

# Clean up after install
RUN rm -rf /var/lib/apt/lists/* 

# Add jrotter
RUN useradd -m jrotter -p hEtUUyGMDs63I -s /bin/bash
RUN adduser jrotter sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set up jrotter VNC
RUN mkdir /home/jrotter/.vnc
RUN chown jrotter /home/jrotter/.vnc
COPY set_vncpasswd.sh /home/jrotter/
RUN su jrotter -c '/bin/sh /home/jrotter/set_vncpasswd.sh'
#RUN rm -f /home/jrotter/set_vncpasswd.sh
#RUN chown jrotter /home/jrotter/.vnc/passwd
RUN touch /home/jrotter/.Xresources
RUN chown jrotter /home/jrotter/.Xresources

# Install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN su jrotter -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
RUN su jrotter -c 'curl -SSL https://get.rvm.io | bash -s stable --ruby'
RUN su jrotter -c '/bin/bash -l -c "rvm install jruby"'
RUN su jrotter -c '/bin/bash -l -c "rvm install 2.0.0"'
RUN su jrotter -c '/bin/bash -l -c "rvm --default use 2.0.0"'
RUN su jrotter -c '/bin/bash -l -c "rvm use jruby && gem install bundler"'
RUN su jrotter -c '/bin/bash -l -c "rvm use 2.0.0 && gem install bundler"'
USER jrotter
COPY onetime.sh /home/jrotter/

# Add local directories
USER jrotter
RUN mkdir /home/jrotter/git

# Update .bashrc
USER jrotter
COPY bashrc.append /home/jrotter/
RUN cat /home/jrotter/bashrc.append >> /home/jrotter/.bashrc
RUN rm -f /home/jrotter/bashrc.append

# Update .vimrc
USER jrotter
Copy .vimrc /home/jrotter/

# Define default command
CMD USER="jrotter" bash -c vncserver :1 -geometry 1280x800 -depth 24 && tail -F /home/jrotter/.vnc/*.log

# Define working directory
WORKDIR /home/jrotter/

# Expose ports
EXPOSE 5901

