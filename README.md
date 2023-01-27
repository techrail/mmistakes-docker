# Docker Image for Minimal Mistakes Jekyll Theme

This repo contains the Dockerfile (and the Gemfile) for the awesome [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) theme for [Jekyll](https://jekyllrb.com/). The image is published in Docker Hub at https://hub.docker.com/r/vaibhavkaushal/mmistakes. You will have to pull from there to use it locally.

I ([Vaibhav](https://github.com/vaibhav-kaushal)) built this image because I keep installing and reinstalling OSes and Virtual Machines and sometimes change my servers. I am fond of the theme and have to install everything everywhere every single time. That's too much work. In addition, there is a problem with jekyll build which causes pain at times (zsh users might have faced it more than others; it involves `LANG` and `LC_CTYPE`). I wanted to get rid of these problems. Creating a docker image that works is the best I could come up with. 

**NOTE**: This image is tested on Ubuntu and macOS only. It should work for most versions of macOS typically in use today and other Linux distros well. It should also work on a Windows machine but I cannot help you much with that if you fall into troubles.

## Which tag should I use?
I have built the image for both ARM64 (should work on Mac with Apple Silicon, AWS G-series machines, Raspberry Pi etc.) and AMD64 (Typical PC/Laptop running Windows or Linux, older Macs with Intel chips, servers with Intel processors).

**IMPORTANT NOTE**: I had a `latest` image but depending on which architecture tag was pushed last, either the AMD64 or ARM64 pull/run won't work; and thus, I deleted that tag. So you can't really do `docker run vaibhavkaushal/mmistakes` (it would fail). Instead you should use either `latest-amd64` or `latest-arm64` tags.

## How to use this docker image to build your Jekyll site?

The container has jekyll and minimal mistakes gem installed. However, there is a small caveat to using it directly.

## Caveats and workaround
Once the generation is complete, the generated site is owned by `root`. That's because Jekyll inside the container runs as the root user inside the container; which is normal for most containers but the output is not the most desirable one.

To overcome that, there is a convenience script named `build_site.zsh` in the image which you can use to change the permissions of the directory where generated site is placed (after generation). That script needs to be passed the user's uid and gid (you will see how to use it below).

The image does not have an [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint) or [CMD](https://docs.docker.com/engine/reference/builder/#cmd) as of now. To run the image, you can run it manually like this:

### For Intel/AMD machines
For machines running on AMD64 architecture (such as MacBooks with Intel Chips, Laptops and Desktops containing Intel or AMD processors or most Machine Instances by cloud providers like DigitalOcean, GCP, Azure etc.):

First pull the image:

```
docker pull vaibhavkaushal/mmistakes:latest-amd64
```

Then, to run it:

```
uid=$(id -u)
gid=$(id -g)
MM_SOURCE=/path/to/site_contents
MM_DESTINATION=/path/to/generated_html

docker run -t -i \
  --mount "type=bind,target=/source,source=$MM_SOURCE"\
  --mount "type=bind,target=/destination,source=$MM_DESTINATION"\
  vaibhavkaushal/mmistakes:latest-arm64\
  /app/build_site.zsh $uid $gid
```

Please replace `/path/to/site_contents` with the path where your `_config.yml` is there (along with all your site markdown files). Also, replace `/path/to/generated_html` with the path where you want the generated site contents to be placed. 

### For ARM64 machines
For machines running on ARM64 architecture (such as MacBooks with Apple Silicon, Raspberry Pi or AWS's G-series EC2 instances etc.):


First pull the image:

```
docker pull vaibhavkaushal/mmistakes:latest-arm64
```

Then, to run it:

```
uid=$(id -u)
gid=$(id -g)
MM_SOURCE=/path/to/site_contents
MM_DESTINATION=/path/to/generated_html

docker run -t -i \
  --mount "type=bind,target=/source,source=$MM_SOURCE"\
  --mount "type=bind,target=/destination,source=$MM_DESTINATION"\
  vaibhavkaushal/mmistakes:latest-arm64\
  /app/build_site.zsh $uid $gid
```

Of course, replace `/path/to/site_contents` with the path where your `_config.yml` is there (along with all your site markdown files). Also, replace `/path/to/generated_html` with the path where you want the generated site contents to be placed. 

## Notes for myself
... because I keep forgetting how to tag and push docker images (if you use CI/CD pipelines for all the grunt work, this happens):

```
docker tag mmistakes:latest vaibhavkaushal/mmistakes:1.1.0-amd64
docker tag mmistakes:latest vaibhavkaushal/mmistakes:latest-amd64
docker tag mmistakes:latest vaibhavkaushal/mmistakes:latest
docker push vaibhavkaushal/mmistakes:1.1.0-amd64
docker push vaibhavkaushal/mmistakes:latest-amd64
docker push vaibhavkaushal/mmistakes:latest
```

Hope this will help you!
