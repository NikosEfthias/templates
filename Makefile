SSH=
NAME=
TARGET=
BUILD_PATH=
DEPLOY_DIR=
$(BUILD_PATH)$(NAME):$(shell find src/ -name "*.rs")
	cargo build --release --target $(TARGET)
strip:$(BUILD_PATH)$(NAME)
	du -h $<
	strip -s $<
	du -h $<
deploy:strip
	@-ssh $(SSH) cp -v $(DEPLOY_DIR)/$(NAME) $(DEPLOY_DIR)/$(NAME).old.$(shell date +"%F-%T")
	rsync -vaurz --progress $(BUILD_PATH)$(NAME) $(SSH):$(DEPLOY_DIR)/
deployService:$(NAME).service
	rsync -vaurz $< $(SSH):/etc/systemd/system/
