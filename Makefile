bash:
	@docker-compose run \
		--rm \
		--name test \
		-p 3000:3000 \
		ruby \
		bash

test.bash:
	@docker exec -it test bash

redis:
	@docker run \
		--rm \
		--name redis \
		redis

network:
	@docker network connect test test
	@docker network connect test redis
