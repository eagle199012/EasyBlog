package com.blog.model;
// Generated 2017-4-2 12:37:59 by Hibernate Tools 5.2.1.Final

import java.util.Date;

import org.codehaus.jackson.map.annotate.JsonSerialize;

import com.blog.utils.CustomDateSerializer;

/**
 * BllPageinfo generated by hbm2java
 */
public class BllPageinfo implements java.io.Serializable {

	private String id;
	private String url;
	private String title;
	private String postTime;
	private String content;
	private String author;
	private String authorPage;
	private Date createTime;
	private String createBy;

	public BllPageinfo() {
	}

	public BllPageinfo(String id) {
		this.id = id;
	}

	public BllPageinfo(String id, String url, String title, String postTime, String content, String author,
			String authorPage, Date createTime, String createBy) {
		this.id = id;
		this.url = url;
		this.title = title;
		this.postTime = postTime;
		this.content = content;
		this.author = author;
		this.authorPage = authorPage;
		this.createTime = createTime;
		this.createBy = createBy;
	}

	public String getId() {
		return this.id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUrl() {
		return this.url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getTitle() {
		return this.title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPostTime() {
		return this.postTime;
	}

	public void setPostTime(String postTime) {
		this.postTime = postTime;
	}

	public String getContent() {
		return this.content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getAuthor() {
		return this.author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public String getAuthorPage() {
		return this.authorPage;
	}

	public void setAuthorPage(String authorPage) {
		this.authorPage = authorPage;
	}

	@JsonSerialize(using = CustomDateSerializer.class)
	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getCreateBy() {
		return this.createBy;
	}

	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}

}
