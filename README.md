# Docker Image for Minimal Mistakes Jekyll Theme

This repo contains the Dockerfile (and the Gemfile) for the awesome [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) theme for [Jekyll](https://jekyllrb.com/). The image is published in Docker Hub at https://hub.docker.com/r/vaibhavkaushal/mmistakes. You will have to pull from there to use it locally.

I built this image because I keep installing and reinstalling OSes and Virtual Machines and sometimes change my servers. I am fond of the theme and have to install everything everywhere every single time. That's too much work. In addition, there is a problem with jekyll build which causes pain at times (zsh users might have faced it more than others; it involves LANG and LC_CTYPE). I wanted to get rid of these problems. Creating a docker image that works is the best I could come up with. 

**NOTE**: This image is tested on Ubuntu and macOS only. It should work for most versions of macOS typically in use today and other Linux distros well. It should also work on a Windows machine but I cannot help you much with that if you fall into troubles.

## Which tag should I use?
I have built the image for both ARM64 (should work on Mac with Apple Silicon, AWS G-series machines, Raspberry Pi etc.) and AMD64 (Typical PC/Laptop running Windows or Linux, older Macs with Intel chips, servers with Intel processors).

You should be able to just run `docker pull vaibhavkaushal/mmistakes` and it should get the latest image for your current architecture but just in case you prefer to have a particular version or arch, you can use a relevant tag (e.g. `1.0.1-arm64` or `latest-amd64`) to get it.

## How to use it?

The image does not have an [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint) or [CMD](https://docs.docker.com/engine/reference/builder/#cmd) as of now. To run the program, you would have to run the command manually:

```
docker run -t -i \
  --mount 'type=bind,target=/source,source=/path/to/site_contents'\
  --mount 'type=bind,target=/destination,source=/path/to/generated_html'\
  mmistakes:latest\
  jekyll build --source /source --destination /destination
```

Please replace `/path/to/site_contents` with the path where your `_config.yml` is there (along with all your site markdown files). Also, replace `/path/to/generated_html` with the path where you want the generated site contents to be placed. 

## Caveats
I have observed that the generated site is owned by `root`. That's because Jekyll inside the container runs as the root user inside the container (which is normal for most containers). So you would probably have to change the ownership of the directory on your machine after the site is generated.

## Notes for myself
... because I keep forgetting how to tag and push docker images (if you use CI/CD pipelines for all the grunt work, this happens):

```
docker tag mmistakes:latest vaibhavkaushal/mmistakes:1.0.1-amd64
docker tag mmistakes:latest vaibhavkaushal/mmistakes:latest-amd64
docker tag mmistakes:latest vaibhavkaushal/mmistakes:latest
docker push vaibhavkaushal/mmistakes:1.0.1-amd64
docker push vaibhavkaushal/mmistakes:latest-amd64
docker push vaibhavkaushal/mmistakes:latest
```

Hope this will help you!
