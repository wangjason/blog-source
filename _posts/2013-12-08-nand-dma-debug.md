---
layout: post
category: driver debug
tagline: "Supporting tagline"
tag : [bootloader, debug, driver]
---
{% include JB/setup %}

###nand 调试信息

* 可以确定，nand开启dma前及传递地址时的数组地址没有问题；

* 在dma开启之前，数组确实已经修改过了，数据全部正确；

* 将同样数据传给非dma方式做过实验，没有问题；

* 只要给page_buf数组在定义的时候同时初始化，page_buf的空间是足够的；
 
* 无论数组是char型的还是int 型的都不可以。

* 如果将数组地址换成一个unsigned int型的数字(代表256k地址)就可以顺利通过。

* 尝试过改变变量类型，改变函数类型都没用

注意:如果page_buf没有赋初值，其objdump -d看到的空间是远远小于正常空间的；(readelf 还没看过呢)

具体实验数据如下:

理想数据应该是:0x1000个0x5a(mw写道地址空间的，后面128个oob数据，即0xffffffff)

	0xefff4000 0x5030201 0x8070605 0x9 0x0 0x0 0x0 0x0 0x0 (这是初始化时写到数组里的)
	0xefff4020 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4040 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 
	0xefff4060 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 
	0xefff4080 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff40a0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff40c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff40e0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4100 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4120 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4140 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4160 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4180 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff41a0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff41c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff41e0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4200 0x0 0x0 0x0 0x0 0x5a 0x5a 0x5a 0x5a 
	0xefff4220 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4240 0x0 0x0 0x0 0x0 0x5a 0x5a 0x5a 0x5a 
	0xefff4260 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4280 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff42a0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff42c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff42e0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4300 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4320 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4340 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4360 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4380 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff43a0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff43c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff43e0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4400 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4420 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4440 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4460 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4480 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff44a0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff44c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff44e0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4500 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4520 0x5a 0x5a 0x5a 0x5a 0x0 0x0 0x0 0x0 
	0xefff4540 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4560 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4580 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff45a0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff45c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff45e0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4600 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4620 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4640 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4660 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4680 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff46a0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff46c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff46e0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4700 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4720 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4740 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4760 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4780 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff47a0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff47c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff47e0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4800 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4820 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4840 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 
	0xefff4860 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 0x5a 
	0xefff4880 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff48a0 0x5a 0x5a 0x5a 0x5a 0x0 0x0 0x0 0x0 
	0xefff48c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff48e0 0x5a 0x5a 0x5a 0x5a 0x0 0x0 0x0 0x0 
	0xefff4900 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4920 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4940 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4960 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4980 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff49a0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff49c0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff49e0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4a00 0x0 0x0 0x0 0x0 0x5a 0x5a 0x5a 0x5a 
	0xefff4a20 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4a40 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4a60 0x5a 0x5a 0x5a 0x5a 0x0 0x0 0x0 0x0 
	0xefff4a80 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4aa0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4ac0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4ae0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4b00 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4b20 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4b40 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4b60 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4b80 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4ba0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4bc0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4be0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4c00 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4c20 0x0 0x0 0x0 0x0 0x5a 0x5a 0x5a 0x5a 
	0xefff4c40 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4c60 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4c80 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4ca0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4cc0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4ce0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4d00 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4d20 0x5a 0x5a 0x5a 0x5a 0x0 0x0 0x0 0x0 
	0xefff4d40 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4d60 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4d80 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4da0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4dc0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4de0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4e00 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4e20 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4e40 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4e60 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4e80 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4ea0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4ec0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4ee0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4f00 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4f20 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4f40 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4f60 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4f80 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4fa0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4fc0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff4fe0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff5000 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff5020 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
	0xefff5040 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 
	0xefff5060 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 

