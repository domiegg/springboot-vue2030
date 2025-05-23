<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<!-- 充值 -->
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>充值</title>
		<!-- bootstrap样式，地图插件使用 -->
		<link rel="stylesheet" href="../../css/bootstrap.min.css" />
		<!-- layui -->
		<link rel="stylesheet" href="../../layui/css/layui.css">
		<!-- 样式 -->
		<link rel="stylesheet" href="../../css/style.css" />
		<!-- 主题（主要颜色设置） -->
		<link rel="stylesheet" href="../../css/theme.css" />
		<!-- 通用的css -->
		<link rel="stylesheet" href="../../css/common.css" />
	</head>
	<body style="background: #EEEEEE;">

		<div id="app">

			<!-- 轮播图 -->
			<div class="layui-carousel" id="swiper">
				<div carousel-item id="swiper-item">
					<div v-for="(item,index) in swiperList" v-bind:key="index">
						<img class="swiper-item" :src="item.img">
					</div>
				</div>
			</div>
			<!-- 轮播图 -->

			<!-- 标题 -->
			<h2 style="margin-top: 20px;" class="index-title">USER ADDRESS</h2>
			<div class="line-container">
				<p class="line" style="background: #EEEEEE;"> 收货地址添加 </p>
			</div>
			<!-- 标题 -->

			<div class="center-container">
				<!-- 个人中心菜单 config.js-->
				<div class="left-container">
					<ul class="layui-nav layui-nav-tree">
						<li v-for="(item,index) in centerMenu" v-bind:key="index" class="layui-nav-item" :class="item.url=='../address/list.jsp'?'layui-this':''">
							<a :href="'javascript:window.location.href=\''+item.url+'\''">{{item.name}}</a>
						</li>
					</ul>
				</div>
				<!-- 添加地址表单 -->
				<div class="right-container" style="padding-top: 0;">
					<form style="margin-top: 20px;" class="layui-form" lay-filter="myForm">
						<div class="layui-form-item layui-form-text">
							<label class="layui-form-label">联系人：</label>
							<div class="layui-input-block">
								<input type="text" name="name" id="name" required lay-verify="required" placeholder="联系人" autocomplete="off"
								 class="layui-input">
							</div>
						</div>
						<div class="layui-form-item layui-form-text">
							<label class="layui-form-label">手机号码：</label>
							<div class="layui-input-block">
								<input type="text" name="phone" id="phone" required lay-verify="required|phone" placeholder="手机号码" autocomplete="off"
								 class="layui-input">
							</div>
						</div>
						<div class="layui-form-item layui-form-text">
							<label class="layui-form-label">默认地址：</label>
							<div class="layui-input-block" style="width: 300px;text-align: left;">
								<input type="radio" name="isdefault" value="是" title="是" checked>
								<input type="radio" name="isdefault" value="否" title="否">
							</div>
						</div>
						<div class="layui-form-item layui-form-text">
							<label class="layui-form-label">地址：</label>
							<div class="layui-input-block">
								<input type="text" name="address" id="address" required lay-verify="required" placeholder="地址" autocomplete="off"
								 class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<div class="layui-input-block" style="text-align: right;margin-right: 30px;">
								<button class="layui-btn btn-submit" lay-submit lay-filter="*">添加</button>
								<button type="reset" class="layui-btn layui-btn-primary">重置</button>
							</div>
						</div>
					</form>
				</div>
			</div>

		</div>

		<!-- layui -->
		<script src="../../layui/layui.js"></script>
		<!-- vue -->
		<script src="../../js/vue.js"></script>
		<!-- 组件配置信息 -->
		<script src="../../js/config.js"></script>
		<!-- 扩展插件配置信息 -->
		<script src="../../modules/config.js"></script>
		<!-- 工具方法 -->
		<script src="../../js/utils.js"></script>
		<!-- 校验格式工具类 -->
		<script src="../../js/validate.js"></script>
		<!-- 地图 -->
		<script type="text/javascript" src="../../js/jquery.js"></script>
		<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=ca04cee7ac952691aa67a131e6f0cee0"></script>
		<script type="text/javascript" src="../../js/bootstrap.min.js"></script>
		<script type="text/javascript" src="../../js/bootstrap.AMapPositionPicker.js"></script>

		<script>
			var jquery = $;

			var vue = new Vue({
				el: '#app',
				data: {
					// 轮播图
					swiperList: [{
						img: '../../img/banner.jpg'
					}],
					centerMenu: centerMenu
				},
				filters: {
					newsDesc: function(val) {
						if (val) {
							if (val.length > 200) {
								return val.substring(0, 200).replace(/<[^>]*>/g).replace(/undefined/g, '');
							} else {
								return val.replace(/<[^>]*>/g).replace(/undefined/g, '');
							}
						}
						return '';
					}
				},
				methods: {
					jump(url) {
						jump(url)
					}
				}
			})

			// 初始化地图插件
			jquery(document).ready(function() {
				// var p = jquery("#address").AMapPositionPicker();
				// jquery("#address").on('click', function() {
				// 	var position = p.AMapPositionPicker('position');
				// 	jquery('#address').val(position.address)
				// });
			});

			layui.use(['layer', 'element', 'carousel', 'http', 'jquery', 'form', 'laypage'], function() {
				var layer = layui.layer;
				var element = layui.element;
				var carousel = layui.carousel;
				var http = layui.http;
				var jquery = layui.jquery;
				var laypage = layui.laypage;
				var form = layui.form;

				var limit = 10;

				// 获取轮播图 数据
				http.request('config/list', 'get', {
					page: 1,
					limit: 5
				}, function(res) {
					if (res.data.list.length > 0) {
						var swiperItemHtml = '';
						for (let item of res.data.list) {
							if (item.name.indexOf('picture') >= 0 && item.value && item.value != "" && item.value != null) {
								swiperItemHtml +=
									'<div>' +
									'<img class="swiper-item" src="' + item.value + '">' +
									'</div>';
							}
						}
						jquery('#swiper-item').html(swiperItemHtml);
						// 轮播图
						carousel.render({
							elem: '#swiper',
							width: swiper.width,height:swiper.height,
							arrow: swiper.arrow,
							anim: swiper.anim,
							interval: swiper.interval,
							indicator: "none"
						});
					}
				});


				// 表单校验
				form.verify({
					phone: function(value, item) {
						if (!isMobile(value)) {
							return '请输入正确的手机号码'
						}
					},
				});

				// 提交表单
				form.on('submit(*)', function(data) {
					data = data.field;
					data.userid = localStorage.getItem('userid');
					console.log(data);
					http.requestJson(`address/add`, 'post', data, function(data) {
						layer.msg('添加成功', {
							time: 2000,
							icon: 6
						}, function() {
							window.history.go(-1);
						});
					});
					return false
				});

			});
		</script>
	</body>
</html>
