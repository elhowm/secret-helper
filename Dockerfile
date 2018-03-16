FROM selenium/standalone-chrome:3.11.0

USER root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get -y update

# Install rvm
RUN apt-get install -y git curl vim
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN source /etc/profile.d/rvm.sh

# Install ruby
RUN /bin/bash -l -c "rvm install 2.4.1"

# Clone and configure application
RUN git clone https://github.com/elhowm/secret-helper
WORKDIR ./secret-helper
RUN /bin/bash -l -c "gem install bundler"
RUN /bin/bash -l -c "bundle"
