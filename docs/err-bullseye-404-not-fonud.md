Debian bullseye版本chroot构建失败

- 问题：指定distribution为bullseye时，在安装chroot时会出现以下错误：

	```bash
	 Err:4 https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye/updates Release 
	 404  Not Found [IP: 101.6.15.130 443]
	```

- 原因：`chroot/etc/apt/sources.list` 中的debian-security源默认是stable/updates，而清华源的是stable-security

	```bash
	deb https://mirrors.tuna.tsinghua.edu.cn/debian bullseye main contrib non-free
	deb-src https://mirrors.tuna.tsinghua.edu.cn/debian bullseye main contrib non-free
	deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye/updates main contrib non-free
	deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye/updates main contrib non-free
	deb https://mirrors.tuna.tsinghua.edu.cn/debian bullseye-updates main contrib non-free
	deb-src https://mirrors.tuna.tsinghua.edu.cn/debian bullseye-updates main contrib non-free
	```

- 解决办法：添加`/usr/lib/live/build/chroot_archives` ，修改bullseye/update为bullseye-security

	```bash
	@@ -99,7 +99,15 @@
	                        sid)
	                            ;;
	-
	+                       bullseye)
	+                           echo "deb ${LB_PARENT_MIRROR_CHROOT_SECURITY} ${LB_PARENT_DISTRIBUTION}-security ${LB_PARENT_ARCHIVE_AREAS}" >> chroot/etc/apt/${_PARENT_FILE}
	+
	+                           if [ "${_PASS}" = "source" ] || [ "${LB_APT_SOURCE_ARCHIVES}" = "true" ]
	+                           then
	+                               echo "deb-src ${LB_PARENT_MIRROR_CHROOT_SECURITY} ${LB_PARENT_DISTRIBUTION}-security ${LB_PARENT_ARCHIVE_AREAS}" >> chroot/etc/apt/${_PARENT_FILE}
	+                           fi
	+                           ;;
	+
	                        *)
	                            echo "deb ${LB_PARENT_MIRROR_CHROOT_SECURITY} ${LB_PARENT_DISTRIBUTION}/updates ${LB_PARENT_ARCHIVE_AREAS}" >> chroot/etc/apt/${_PARENT_FILE}
	```

	添加后，`chroot/etc/apt/sources.list`的源变为：

	```bash
	deb https://mirrors.tuna.tsinghua.edu.cn/debian bullseye main contrib non-free
	deb-src https://mirrors.tuna.tsinghua.edu.cn/debian bullseye main contrib non-free
	deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
	deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
	deb https://mirrors.tuna.tsinghua.edu.cn/debian bullseye-updates main contrib non-free
	deb-src https://mirrors.tuna.tsinghua.edu.cn/debian bullseye-updates main contrib non-free
	```

