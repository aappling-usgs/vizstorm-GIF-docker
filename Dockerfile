FROM rocker/geospatial:3.5.1

# install node and npm (see https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
RUN sudo apt-get install -y curl &&\
  sudo apt-get install -y gnupg &&\
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - &&\
  sudo apt-get update &&\
  sudo apt-get install -y nodejs &&\
  sudo apt-get install -y build-essential &&\
  sudo apt-get install -y imagemagick &&\
  sudo apt-get install -y gifsicle

# install
RUN sudo npm install -g\
  webpack\
  webpack-cli\
  d3-geo-projection

# for use when building the docker image: mapping to this docker-building repo
RUN mkdir /home/rstudio/vizstorm-GIF-docker
VOLUME /home/rstudio/vizstorm-GIF-docker

# you should have run packrat::restore() from within the container today,
# which will allow this line to install up-to-date packages into the image.
COPY ./packrat/lib/x86_64-pc-linux-gnu/3.5.1/ /usr/local/lib/R/library

# for use when developing the vizzy project: volume mapping
# allows you to directly edit the project files on your computer
RUN mkdir /home/rstudio/vizstorm-GIF
VOLUME /home/rstudio/vizstorm-GIF
