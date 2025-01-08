主机IP段被镜像站屏蔽

- 问题：lb build构建bootstrap_debootstrap 报403错误

	```bash
	[2024-11-25 03:47:04] lb bootstrap_cdebootstrap
	[2024-11-25 03:47:04] lb bootstrap_debootstrap
	P: Begin bootstrapping system...
	[2024-11-25 03:47:04] lb testroot 
	P: Running debootstrap (download-only)...
	I: Retrieving InRelease
	I: Retrieving Release
	E: Failed getting release file https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/dists/focal/Release                   
	P: Begin unmounting filesystems...
	
	```

	```bash
	wget https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/dists/focal/Release
	
	--2024-11-25 06:23:45--  https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/dists/focal/Release
	Resolving mirrors.tuna.tsinghua.edu.cn (mirrors.tuna.tsinghua.edu.cn)... 101.6.15.130, 2402:f000:1:400::2
	Connecting to mirrors.tuna.tsinghua.edu.cn (mirrors.tuna.tsinghua.edu.cn)|101.6.15.130|:443... connected.
	HTTP request sent, awaiting response... 403 Forbidden
	2024-11-25 06:23:45 ERROR 403: Forbidden.
	```

- 解决：设置指定的User-Agent

	```bash
	sudo -s
	echo 'user_agent = Mozilla' >> ~/.wgetrc
	```
