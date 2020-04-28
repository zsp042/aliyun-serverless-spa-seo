# 用阿里云函数配合又拍云CDN、阿里云CDN对单页面应用做搜索引擎爬虫SEO静态化(用户访问依然还是原始的HTML)

这里是基于阿里云函数的puppeteer静态化脚本

配合又拍云的边缘规则做可以基于CDN的SEO，效果如下图
![](https://tqimg.github.io/20200428233857.png)

测试代码：

* `curl --user-agent "Googlebot"  https://renwu.cool/join`
* `curl  https://renwu.cool/join`

又拍云边缘规则如下

![](https://tqimg.github.io/20200428234640.png)


爬虫抓取的边缘规则

```
$WHEN(
	$MATCH(
		$LOWER($_HEADER_user_agent),
		'bot\\b|spider\\b|yandex|facebookexternalhit|embedly|quora link preview|outbrain|vkShare|whatsapp'
	),
	$NOT(
		$MATCH(
			$LOWER($_URI), '\\.'
		)
	)
) $_URI.html
```

普通访问的边缘规则

```
$WHEN($NOT($MATCH($LOWER($_URI), '\\.'))) /
```

可以配置下缓存时间，如下图

![](https://tqimg.github.io/20200428234817.png)

nginx配置 [参见这里](https://gist.github.com/173ddd5174d990b4bc9cc5d4c22006d8)

此外，泛域名解析重定向可以用阿里云CDN的边缘规则 ( [Let's Encrypt泛域名证书自动上传脚本](https://gist.github.com/TqLj/311ed6213b4d1e8183f8ceb55024f8e4) ，配合 acme.sh 使用 )

![](https://tqimg.github.io/20200428235128.png)

```
rewrite(concat('https://renwu.cool',$request_uri), 'enhance_redirect', 301)
```

这样可以完全隐藏服务器的真实IP，防止被攻击



