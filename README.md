# LiveBuilder

## 介绍

**LiveBuilder** 是基于[live-build](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html) 构建 Debian/Ubuntu 文件系统镜像的软件包。能够快速自动化编译构建目标版本镜像。此外，还可以根据预配置进行自定义系统配置、预装系统软件包等，实现定制化文件系统。

live-build源码：https://salsa.debian.org/live-team/live-build

live-build文档：[https ://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html)

**LiveBuilder**主要针对于ARM架构的嵌入式文件系统开发。基于minbase系统上进行了初步的构建，默认系统具备以下功能：

- 用户权限：root:heyroot	admin:admin
- 系统服务：Systemd, journald
- 网络管理：Netplan, NetworkManager, ufw
- 网络服务：SSH, Telnet, NTP, DHCP, DNS, Tcpdump



## 可构建版本

| 版本                     | 支持架构            |
| :----------------------- | :------------------ |
| **Debian 11 "Bullseye"** | **Armhf and Arm64** |
| **Debian 12 "Bookworm"** | **Armhf and Arm64** |
| **Ubuntu 20.04 "Focal"** | **Armhf and Arm64** |
| **Ubuntu 22.04 "Jammy"** | **Armhf and Arm64** |

如需构建其他版本和架构，可参考定制与扩展。



## 环境要求

推荐使用Ubuntu 20.04的系统进行编译/构建，其他的Linux版本可能需要对软件包进行相应的调整。除了系统要求外，还有硬件软件方面的要求：

- 硬件要求：64位AMD系统
- 软件要求：Ubuntu 20.04系统，具备root权限

开发者使用Ubuntu 20.04 系统进行调试开发，建议使用Ubuntu 20.04或者更高版本。



## 使用

- **获取工程源码，进入工程目录**

	```bash
	git clone https://github.com/rockBonze/LiveBuilder.git
	cd LiveBuilder
	```

- **安装所需的软件包和依赖**

  ```bash
  sudo dpkg -i ./tools/*
  sudo apt-get install -f
  ```

- **选择构建系统和对应的版本**

  ```bash
  cp ./configure/ubuntu_jammy_arm64 .config
  make config
  ```

  执行后，会在`build/config/`目录下生成配置，后续的编译依靠这些配置项进行。

- **编译文件系统**

  ```bash
  make
  ```

  编译后会在`build/`目录下生成binary文件系统根目录，以及对应的日志，缓存包。

- **制作文件系统镜像**

  ```bash
  make image
  ```

  制作完成后，会在`build/image`目录下生成文件系统镜像。

- **重新构建**

  相同的系统和版本：

  ```bash
  make clean
  make config
  make && make image
  ```

  重新构建不同的系统或版本：

  ```bash
  make deepclean
  cp ./configure/system_distribution_arm64 .config
  make config
  make && make image
  ```



## 定制与扩展

- **定制其他版本和架构**

	如要定制其他版本号或者其他架构的系统，参考`configure`目录下的配置并修改`lb config`的参数。其他的架构和版本可能不兼容默认配置的软件包和配置项，需根据编译或使用过程中的错误进行调整。

- **修改默认系统配置**

	默认系统配置在`LiveBuilder/custom/`目录下，可根据自身系统需求进行修改。

- **自定义软件包**

	**LiveBuilder**的自定义软件包使用的是`deb`格式，在制作镜像之前将`deb`包制作好。制作镜像时会自动安装自定义软件包。

	```bash
	make deb && make image
	```

	执行`make deb`后，会自动构建`packages`目录下的自定义软件包，构建后的路径位于`build/deb_packages`。

	

## 注意事项

- **问题：编译/构建遇到ERROR:403错误码**

	解决：设置指定的User-Agent。

	```bash
	sudo -s
	echo 'user_agent = Mozilla' >> ~/.wgetrc
	```

- **问题：编译/构建所需的时间过长**

	解决：检查网络环境，更换国内镜像源，例如清华源。其他的源在`LiveBuilder/docs/apt_sources_list.txt`中

	```bash
	lb config \
	  --mirror-bootstrap "http://mirrors.ustc.edu.cn/debian" \
	  --mirror-chroot "http://mirrors.ustc.edu.cn/debian" \
	  --mirror-chroot-security "http://mirrors.ustc.edu.cn/debian-security" \
	  --mirror-binary "http://mirrors.ustc.edu.cn/debian" \
	  --mirror-binary-security "http://mirrors.ustc.edu.cn/debian-security" \
	```

- **问题：短时间内频繁构建导致本地IP被镜像站屏蔽**

  解决：使用缓存包代替镜像站下载，不同版本的默认缓存包到下载里下载。

  将压缩包解压至工程目录下，生成`cache/`目录。

  ```bash
  sudo tar -xzf xxx_xxx_cache.tar.gz -C LiveBuilder/
  cd LiveBuilder && make preapre
  ```

  最后会在`build/`目录下生成`cache/`目录。

- **问题：如何快速适配不同开发板**

	解决：主要适配网络接口配置文件和分区配置文件

	- `/etc/netplan/*.yaml`
	- `/etc/default/isc-dhcp-server`  
	- `/etc/ufw/before.rules` 
	- `/etc/fstab`
	



## 下载

**ARM64各系统版本的软件缓存包，点击[下载](https://drive.google.com/drive/folders/1O4w3z7xb0WTiNWYT4ClP9_eU1cYgTlQK?usp=sharing)**



## 联系

**如果有任何疑问、建议或需要帮助，请联系Email:  rockbonze@163.com**
