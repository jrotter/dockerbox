build:
	docker build -t dev-jrotter .

run: start
start:
	docker run -it -d -p 5910:5901 --name=dev_instance_jrotter -v /mnt/nfs/home/jrotter/git:/home/jrotter/git dev-jrotter

stop:
	docker stop dev_instance_jrotter && docker rm dev_instance_jrotter
