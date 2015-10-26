Build with

docker build -t devclient .

Run with:

docker run -it --rm -p 5910:5901 --name=my_first_dev_instance -v /mnt/nfs/home/jrotter/git:/home/jrotter/git devclient

This will attach the image to local port 5900.  If you vnc://host:5900, you can connect

Kill with:

docker stop my_first_dev_instance ; docker rm my_first_dev_instance
