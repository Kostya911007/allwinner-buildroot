#!/bin/bash

PLATFORM=""
MODULE=""
CUR_DIR=`pwd`

show_help()
{
	printf "\nbuild.sh - Top Level Build Scripts\n\n"
	echo "Valid Options:"
	echo "  -h  Show help message"
	echo "  -p <platform> platform"
	printf "  -m <module> module, default to all\n"
	printf "\nValid Platforms:\n"
	printf "  sun4i        : full sun4i platform, including directfb, ...\n"
	printf "  sun4i-lite   : lite sun4i platform, which has much less packages\n"
	printf "  sun4i_crane  : for android, only have toolchain and kernel\n"
	printf "  sun4i-debug  : for debug purpose\n\n"
	printf "Valid Modules:\n"
	printf "  kernel       : build linux kernel\n"
	printf "  buildroot    : toolchain and package\n"
	printf "  all          : kernel, buildroot, and auto packing\n\n"
	printf "Examples:\n  ./build.sh -p sun4i\n"
	printf "  ./build.sh -p sun4i -m buildroot\n"
	printf "  ./build.sh -p sun4i -m kernel\n\n"
}

regen_rootfs()
{
	echo "Regenerating Rootfs..."
	if [ -d ${CUR_DIR}/buildroot/output/target ]; then
		mkdir -p ${CUR_DIR}/buildroot/output/target/lib/modules
		cp -rf ${CUR_DIR}/linux-2.6.36/output/lib/modules/* \
			${CUR_DIR}/buildroot/output/target/lib/modules/

		if [ "$PLATFORM" = "sun4i-debug" ]; then
			cp -rf ${CUR_DIR}/linux-2.6.36/vmlinux ${CUR_DIR}/buildroot/output/target
		fi

		cd ${CUR_DIR}/buildroot
		make rootfs-ext2
		#make rootfs-tar
		#make rootfs-cpio

	else
		echo "Skip Regenerating Rootfs..."
	fi
}

gen_output_sun3i()
{
	echo "output sun3i"
}

gen_output_sun4i()
{
	cp -v ${CUR_DIR}/linux-2.6.36/output/bImage \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_win/wboot
	cp -v ${CUR_DIR}/buildroot/output/images/rootfs.ext2 \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_win/wboot/rootfs.fex

	cp -v ${CUR_DIR}/linux-2.6.36/output/bImage \
        ${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot
	cp -v ${CUR_DIR}/buildroot/output/images/rootfs.ext2 \
        ${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot/rootfs.fex

	if [ -e ${CUR_DIR}/buildroot/output/images/u-boot.bin ]; then
		cp -v ${CUR_DIR}/buildroot/output/images/u-boot.bin \
        	${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot
		cp -v ${CUR_DIR}/linux-2.6.36/output/uImage \
        	${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot
	fi

	if [ ! -d "${CUR_DIR}/out" ]; then
		mkdir -pv ${CUR_DIR}/out
	fi

	cp -v ${CUR_DIR}/buildroot/output/images/* ${CUR_DIR}/out/
	cp -r ${CUR_DIR}/linux-2.6.36/output/* ${CUR_DIR}/out/

	echo "Packing for sun4i platform"
	(cd ${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot; ./image.sh)

}

gen_output_sun4i-lite()
{
	cp -v ${CUR_DIR}/linux-2.6.36/output/bImage \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_win/wboot
	cp -v ${CUR_DIR}/buildroot/output/images/rootfs.ext2 \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_win/wboot/rootfs.fex


	cp -v ${CUR_DIR}/linux-2.6.36/output/bImage \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot
	cp -v ${CUR_DIR}/buildroot/output/images/rootfs.ext2 \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot/rootfs.fex

	if [ -e ${CUR_DIR}/buildroot/output/images/u-boot.bin ]; then
		cp -v ${CUR_DIR}/buildroot/output/images/u-boot.bin \
        	${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot
		cp -v ${CUR_DIR}/linux-2.6.36/output/uImage \
        	${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot
	fi

	if [ ! -d "${CUR_DIR}/out" ]; then
		mkdir -pv ${CUR_DIR}/out/
	fi

	cp -v ${CUR_DIR}/buildroot/output/images/* ${CUR_DIR}/out/
	cp -r ${CUR_DIR}/linux-2.6.36/output/* ${CUR_DIR}/out/

	echo "Packing for sun4i platform"
	(cd ${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot; ./image.sh)
}

gen_output_sun4i-debug()
{
	cp -v ${CUR_DIR}/linux-2.6.36/output/bImage \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_win/wboot
	cp -v ${CUR_DIR}/buildroot/output/images/rootfs.ext2 \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_win/wboot/rootfs.fex


	cp -v ${CUR_DIR}/linux-2.6.36/output/bImage \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot
	cp -v ${CUR_DIR}/buildroot/output/images/rootfs.ext2 \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot/rootfs.fex

	if [ -e ${CUR_DIR}/buildroot/output/images/u-boot.bin ]; then
		cp -v ${CUR_DIR}/buildroot/output/images/u-boot.bin \
        	${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot
	cp -v ${CUR_DIR}/linux-2.6.36/output/uImage \
        	${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot
	fi

	if [ ! -d "${CUR_DIR}/out" ]; then
		mkdir -pv ${CUR_DIR}/out
	fi

	cp -v ${CUR_DIR}/buildroot/output/images/* ${CUR_DIR}/out/
	cp -r ${CUR_DIR}/linux-2.6.36/output/* ${CUR_DIR}/out/

	echo "Packing for sun4i-debug platform"
	(cd ${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot; ./image.sh)

}

gen_output_sun4i_crane()
{
	cp -v ${CUR_DIR}/linux-2.6.36/output/bImage \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_lin/wboot/bootfs/linux/
	cp -v ${CUR_DIR}/linux-2.6.36/output/bImage \
		${CUR_DIR}/buildroot/tools/pack/sun4i_pack_win/wboot/bootfs/linux/
	echo "test" > ${CUR_DIR}/buildroot/tools/pack/sun4i_pack_win/wboot/rootfs.fex

	if [ -d "${CUR_DIR}/out" ]; then
		mkdir -pv ${CUR_DIR}/out
	fi

	cp -r ${CUR_DIR}/linux-2.6.36/output/* ${CUR_DIR}/out/
}

clean_output()
{
	rm -f ${CUR_DIR}/out/*
	rm -f ${CUR_DIR}/buildroot/output/images/*
	rm -f ${CUR_DIR}/linux-2.6.36/output/*
}

while getopts hp:m: OPTION
do
	case $OPTION in
	h) show_help
	;;
	p) PLATFORM=$OPTARG
	;;
	m) MODULE=$OPTARG
	;;
	*) show_help
	;;
esac
done

if [ -z "$PLATFORM" ]; then
	show_help
	exit 1
fi

clean_output

if [ "$MODULE" = buildroot ]; then
	cd ${CUR_DIR}/buildroot && ./build.sh -p ${PLATFORM}
elif [ "$MODULE" = kernel ]; then
	export PATH=${CUR_DIR}/buildroot/output/external-toolchain/bin:$PATH
	cd ${CUR_DIR}/linux-2.6.36 && ./build.sh -p ${PLATFORM}
	regen_rootfs
	gen_output_${PLATFORM}
else
	cd ${CUR_DIR}/buildroot && ./build.sh -p ${PLATFORM}
	export PATH=${CUR_DIR}/buildroot/output/external-toolchain/bin:$PATH
	cd ${CUR_DIR}/linux-2.6.36 && ./build.sh -p ${PLATFORM}
	regen_rootfs
	gen_output_${PLATFORM}
fi


