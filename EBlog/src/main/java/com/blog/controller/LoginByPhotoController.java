package com.blog.controller;

import java.awt.image.BufferedImage;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import com.blog.vo.MenuTree;
import com.blog.model.SysUsers;
import com.blog.service.AuthService;
import com.blog.service.UserService;
import com.blog.utils.CoreConsts;
import com.blog.utils.ImageCompareHelper;
import com.blog.utils.JsonHelper;
import java.util.List;

/**
 * @author：Tim
 * @date：2017年7月15日 下午11:20:40
 * @description：通过头像登录
 */
@Controller
@RequestMapping("/LoginByPhoto")
public class LoginByPhotoController {

	@Autowired
	private UserService userService;

	@Autowired
	private AuthService authService;// 权限

	@RequestMapping("/photoLogin")
	@ResponseBody
	public Map<String, String> photoLogin(@RequestParam(value = "userPhoto", required = true) String userPhoto,
			HttpServletRequest request, HttpServletResponse response) {
		String imgPath = generateImage(userPhoto);// 获取临时头像
		String imgFingerPrint = ImageCompareHelper.produceFingerPrint(imgPath);// 计算头像指纹
		// 查找数据库中用户表的指纹，进行匹配
		List<SysUsers> userList = userService.getUserHasPhotoList();
		for (SysUsers sysUsers : userList) {
			double similarty = ImageCompareHelper.getSimilarty(sysUsers.getPhotoFingerPrint(), imgFingerPrint);

			System.out.println(similarty);
			// 相似度大于或等于阈值，则认为匹配成功，登录通过
			if (similarty >= CoreConsts.ExecuteContextKeys.SIMILARTY) {
				// 登录成功，则设置全局用户信息，在其他页面检测是否经过登录
				HttpSession session = request.getSession();
				response.setHeader("Pragma", "No-cache");// 清理缓存
				response.setHeader("Cache-Control", "no-cache");
				response.setDateHeader("Expires", 0);

				// 放入当前登录的用户
				session.setAttribute(CoreConsts.ExecuteContextKeys.CURRENT_USER, sysUsers);

				// 根据用户角色，获取用户的权限菜单
				List<MenuTree> menus = authService.getMenuTree(sysUsers.getUserCode());

				// 放入当前用户的菜单，登录后获取生成菜单
				session.setAttribute(CoreConsts.ExecuteContextKeys.CURRENT_MENU, menus);

				return JsonHelper.getSucessResult(true);
			}
		}

		return JsonHelper.getSucessResult(false);
	}

	/**
	 * 将base64字符串转化成图片
	 * @param imgDataSrc
	 * @return 生成的图片路径
	 */
	private String generateImage(String imgDataSrc) {
		if (imgDataSrc == null) {
			return null;
		}

		BASE64Decoder decoder = new BASE64Decoder();
		try {
			byte[] imgBytes = decoder.decodeBuffer(imgDataSrc);
			for (int i = 0; i < imgBytes.length; i++) {
				// 调整异常数据
				if (imgBytes[i] < 0) {
					imgBytes[i] += 256;
				}
			}

			// 生成图片
			String imgFilePath = "/media/tim/软件/login.jpg";

			OutputStream out = new FileOutputStream(imgFilePath);
			out.write(imgBytes);
			out.flush();
			out.close();

			return imgFilePath;

		} catch (Exception e) {
			return null;
		}
	}
}
