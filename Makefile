bash:
	@docker-compose run \
		--rm \
		--name app \
		-p 3000:3000 \
		ruby \
		bash

app.bash:
	@docker exec -it app bash

redis:
	@docker run \
		--rm \
		--name redis \
		--network test \
		redis
