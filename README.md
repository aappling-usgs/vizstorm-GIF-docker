# vizstorm-GIF-docker

<style>
win7 {
    color: blue;
} 
</style>

# Vizzy Development Mode: Using the docker image created here to work on the vizzy contents

## Preparing the vizzy for use with the docker image

Navigate to the `gage-conditions` project directory. There should be a file called docker-compose.yml in that repo that will do configuration for you. You will need to edit the volume mapping line to point to your vizzy repo, though.

My docker-compose.yml in `gage-conditions` contains this line, where is the `/D_DRIVE...` path to the left of the colon that I had to customize to my computer:
```
    volumes:
      - "/D_DRIVE/APAData/Github/DS Vizzies/gage-conditions:/home/rstudio/gage-conditions"
```

This appears to be simpler on Windows 10, where maybe you can use a standard Windows path on the left-hand side.


## Launching the docker container

Open a bash shell. <win7>In Windows 7, run Docker Quickstart Terminal <em>as administrator, with VPN off.</em></win7>

Launch a container from the docker image:
```
docker-compose up
```

Next, in your browser, navigate to `localhost:8787` <win7>In Windows 7, replace `localhost` with the specific IP given by `docker-machine ip default`. Still affix the colon and port number 8787, e.g., `http://192.168.99.100:8787`.</win7> Login with username=`rstudio` and password=`rstudio`.

In the RStudio Files pane, click on your project directory and then on the project .proj file to open your project as an RStudio project.

## Doing vizzy stuff

Edit project files either from within that browser RStudio or from your usual RStudio application. `git push` and `git pull` the project files from your usual RStudio application. Run `vizmake()` from within the browser RStudio.

## Managing your images and containers

To view the image in coarse and fine detail, respectively:
```
docker image ls
docker image inspect aapplingusgs/gage-conditions
```

To see, stop, and remove running containers, respectively (`container_name` should be replaced with the hash or goofy name assigned to the container, which you can see by running `docker container ls`):
```
docker container ls
docker container stop container_name
docker container rm container_name
```

When you're done with the image for now:
```
docker-compose down
```

# Setting up the Docker ecosystem (any OS).

You'll need to download, install, and configure Docker. For most systems, you need Docker for Win/Mac/Linux from https://download.docker.com/. For Windows 7/8, download Docker Toolbox from https://docs.docker.com/toolbox/toolbox_install_windows/.

## Setting up Docker for Windows (Windows 10)

Follow these instructions generally for Windows 10: https://store.docker.com/editions/community/docker-ce-desktop-windows.

Follow these steps to get Docker for Windows to run on Windows 10: https://github.com/docker/for-win/issues/868#issuecomment-352279510. These steps add your logon account to a Windows group called docker-users.

You need to go into settings and add your username to something Docker something something - ask Jake.

<win7>
## Setting up VirtualBox for Windows 7/8

All of the following things need to happen running Oracle VirtualBox and/or the windows command prompt *as administrator*. Don't forget or it won't work. For most of these changes you'll need to shut down the virtual machine to be able to make the changes.

You'll need to configure the docker-machine VirtualBox image to share a directory or two with you. Because it's all happening on your local machine anyway, it should be fine to share an entire drive via VirtualBox and then just map specific folders from within the docker-compose.yml file. Right click on VirtualBox, open as administrator. Right click on the `default` machine, select Settings, select Shared Folders, click the icon with the plus sign to add a folder. Name it `D_DRIVE` and map it to `D:\`, or use whatever comparable mapping is appropriate to your computer. Restart `docker-machine`.

The volumes you map with docker-compose.yml will need to be within that shared folder and should use that mapped-drive name in its file path. For example, my mapped drive is `/D_DRIVE` and the paths I use for gage-conditions are `/D_DRIVE/APAData/Github/DS Vizzies/gage-conditions-docker` and `/D_DRIVE/APAData/Github/DS Vizzies/gage-conditions`.</win7>

To modify the docker image, Packrat needs to be able to create symlinks in your shared folders. To enable this, follow the instructions here: http://jessezhuang.github.io/article/virtualbox-tips/. For example, if you have the usual docker-machine VM named `default` and a shared drive named `D_DRIVE`, you should open a Windows command prompt, navigate to the folder containing `VBoxManage.exe` (probably Program Files/Oracle/VirtualBox or similar), and then run
```
VBoxManage setextradata default VBoxInternal2/SharedFoldersEnableSymlinksCreate/D_DRIVE 1
```
This symlink stuff may be mysterious but is super important - without it, packrat is unwilling to reuse the packages already installed on `rocker/geospatial`.

You will probably want more memory and cores than the `default` machine comes with, especially once you get into running your project. From within VirtualBox Manager, right click on the `default` machine, select Settings, select System, and add more memory and more processors. I currently max out the green areas and might eventually even push into the red areas on days when I'm putting all my processing power into the Docker container.

</win7>


# Image Development Mode: Developing your Docker image

## Prepare `gage-conditions-docker`, a project repository to build the Docker image

Create a git repo and add a docker-compose.yml, where the `volumes` line should map your project directory (`.`) into an aptly named folder within `/home/rstudio/` on the Docker image, e.g., `/home/rstudio/gage-conditions-docker`. The Dockerfile should have a `VOLUME` line that expects this mapping.

In the Dockerfile:
```
RUN mkdir /home/rstudio/gage-conditions-docker
VOLUME /home/rstudio/gage-conditions-docker
RUN mkdir /home/rstudio/gage-conditions
VOLUME /home/rstudio/gage-conditions
```

In docker-compose.yml in `gage-conditions-docker`:
```
    volumes:
      - "/D_DRIVE/APAData/Github/DS Vizzies/gage-conditions-docker:/home/rstudio/gage-conditions-docker"
      - "/D_DRIVE/APAData/Github/DS Vizzies/gage-conditions:/home/rstudio/gage-conditions"
```

## Install non-R software

To revise the non-R software on the docker image, add RUN lines to the Dockerfile. Example:
```
RUN sudo npm install -g\
  webpack\
  webpack-cli\
  d3-geo-projection
```

## Installing R packages

To revise the R packages on the docker image, launch a container from the image and make your changes via packrat from within the docker container. 

To launch:
```
docker-compose up
```
Next, in your browser, navigate to `localhost:8787` <win7>In Windows 7, replace `localhost` with the specific IP given by `docker-machine ip default`. Still affix the colon and port number 8787, e.g., `http://192.168.99.100:8787`.</win7> Login with username=`rstudio` and password=`rstudio`.

In the RStudio Files pane, click on your project directory and then on the project .proj file to open your project as an RStudio project. When you open `gage-conditions-docker`, simply opening the project will launch packrat mode (because we've already called `packrat::init()` to modify the `.Rprofile` for this purpose).

Start by getting your local packrat/lib up to date with the packrat/packrat.lock file, which you may have pulled from GitHub with changes:
```r
packrat::restore()
```

Run the symlink-creation code found in .update.R. Really, you can just walk through that file to get all this packrat stuff done.

Add each new R package you want by (1) installing it with `install.packages` or `devtools::install_github`, and (2) adding a `library(pkg)` call to packages.R.

Once all the new packages are installed and libraried, call
```r
packrat::snapshot()
```
to update the `packrat` directory with information about the packages you've installed. This call changes the `packrat/packrat.lock` file.

Run the symlink-deletion code found in .update.R. This will be important the next time you try to call `packrat::restore()`.

Stop the docker container when you're done.
```
docker-compose down
```

`git commit` and `push` the changes you've made to the `gage-conditions-docker` git repo. These changes should include the `packrat/packrat.lock` file and all .tar.gz files in the `packrat/src` folder.

We use Git LFS to sync the tar.gz package bundles; this should already be properly configured in .gitattributes, but you'll also need to install Git LFS from https://git-lfs.github.com/ before it'll work. After that, just `git commit`, `push`, and `pull` as usual.


## Rebuilding the image

Once you have revised the Dockerfile and the packrat repo.

To build or rebuild the docker image, first check in the docker-compose.yml to make sure the `image:` name includes the appropriate tag. You should probably increment the tag each time you make and intend to publish a change to the image. Then run:
```
docker-compose build
```

The custom R packages are handled in the Dockerfile in the `COPY` line that copies files from your local `./packrat/lib` into the system lib folder on the docker container.

## Publishing the image

Push your image to Docker Hub as soon as you're ready for others to access it.
```
docker push USGS-VIZLAB/gage-conditions:0.1.0
```
(Replace `USGS-VIZLAB/gage-conditions` with your actual image repository name, and remember to update the tag number each time you build a changed version.)


# How this repo was initialized

I ran the code in `.setup.R` to initialize this repo.

## Initializing packrat

In a fresh R session in this repository:
```r
install.packages('packrat')
packrat::init()
```
It's also a good idea to ignore all packages that are already installed on the Docker image we'll be using, at least until we discover that we need a different version of one of those packages. You can get a list of the R packages already available on the `rocker/geospatial` image by running this line while within the docker container and while packrat mode is `off`:
```
packrat::off()
rocker_pkgs <- rownames(installed.packages()) # then I converted this to a literals vector so it'll still work on future iterations of the image
packrat::on()
```
Now you can update the options as follows:
```
packrat::set_opts(
  ignored.packages=rocker_pkgs,
  external.packages=rocker_pkgs,
  load.external.packages.on.startup=FALSE)
```

## Initializing Git LFS

Install Git LFS from https://git-lfs.github.com/. This allows us to store more on GitHub. We get 1GB storage and 1GB downloads free per user, and it's only $5/mo to add additional increments of 50GB storage and 50GB bandwidth. To install, (1) download the executable from the above website, then (2) run `git lfs install`.

If you're the first one setting up a docker-image-creating repo like this one, run:
```
git lfs track "packrat/src/*"
git add .gitattributes
```

## Initializing packrat+docker

These lines need to go in the Dockerfile, and then all the package installation will be taken care of by packrat rather than package-specific calls in the Dockerfile.
```sh
COPY ./packrat/lib/x86_64-pc-linux-gnu/3.5.1/ /usr/local/lib/R/library
```

## Initializing the Docker image

To build the bare-bones image, I commented out the `RUN` command beginning with `RUN R --args --bootstrap-packrat` in the Dockerfile, then ran:
```
docker-compose build
```
After that initial build, I then uncommented that command and proceeded to start adding R packages.

