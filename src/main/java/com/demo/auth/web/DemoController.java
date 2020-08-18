package com.demo.auth.web;

import com.demo.auth.bean.ChatMessage;
import com.demo.auth.model.User;
import com.demo.auth.common.CommonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class DemoController {


	@Autowired
	MessageSource messageSource;

	  @RequestMapping(value = {"/list" }, method = RequestMethod.GET) public
	  ModelAndView welcome(ModelMap model) { 
	  model.addAttribute("user", CommonUtil.getUsername());
	  return new ModelAndView("dashboard"); }
	 
	

	@RequestMapping(value = {"/403", "/400", "/404"}, method = RequestMethod.GET)
	public final ModelAndView accesssDenied() {
		ModelAndView model = new ModelAndView();
		// check if user is login
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (!(auth instanceof AnonymousAuthenticationToken)) {
			UserDetails userDetail = (UserDetails) auth.getPrincipal();
			model.addObject("username", userDetail.getUsername());
		}
		model.setViewName("error");
		return model;
	}

	@RequestMapping(value = { "/chat" }, method = RequestMethod.GET)
	public String chatModule(ModelMap model) {
		User user = new User();
		model.addAttribute("userModel", user);
		model.addAttribute("user",CommonUtil.getUsername());
		return "chat";
	}

	@MessageMapping("/chat.sendMessage")
	@SendTo("/topic/public")
	public ChatMessage sendMessage(@Payload ChatMessage chatMessage) {
		return chatMessage;
	}

	@MessageMapping("/chat.addUser")
	@SendTo("/topic/public")
	public ChatMessage addUser(@Payload ChatMessage chatMessage,
							   SimpMessageHeaderAccessor headerAccessor) {
		// Add username in web socket session
		headerAccessor.getSessionAttributes().put("username", chatMessage.getSender());
		return chatMessage;
	}
}
