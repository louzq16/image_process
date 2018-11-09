# 文件说明
* 非.m文件
** best.jpg 所选出的拼接效果比较好的一张图
** myself.jpg  自己拍的图所拼接出来的图
** img目录：作业所给的9张图像
** img2目录：自己拍的5张图像
** '作业拼接图像'目录 对img中9张图像按照不同中心图像拼接的3三张图像

* .m文件
** GetTransmatrix  获取透视变换矩阵 【m函数】
** imgRW 读取指定目录下所有jpg图像输出为元胞数组 【m函数】
** myRANSAC RANSAC算法实现，筛选好的匹配特征点 【m函数】
** myReinhard Reinhard实现 ，调整色差 【m函数】
** myImgtrans 利用变换矩阵变换图像 【m函数】
** myImggregist 调用以上m函数，完成图像配准 【m函数】
** myImgfuse 实现图像融合输出最终拼接图像 【m函数】

** ImgMosaick 运行此脚本，得到以1.jpg为中心图像的拼接图像 【脚本】
** myImgs_Mosaick 运行此脚本，得到我自己所拍的图片的拼接图像 【脚本】

#程序运行说明
*运行上面的两个脚本ImgMosaick myImgs_Mosaick可分别得到作业要求的拼接图像和我自己所拍图片的拼接图像
*对ImgMosaick中的center变量进行更改可得到不同中心图像的拼接图像
*myImgs_Mosaick 不建议更改，当然助教您也可以试一下
*若要运行m函数请见函数文件注释
*best.jpg为已经拼接好的图像助教可以先看看