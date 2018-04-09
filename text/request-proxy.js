'use strict';

const urllib = require('urllib');
const cheerio = require('cheerio');
const iconv = require('iconv-lite');

urllib.request('http://www.ip138.com/ips1388.asp', {
		enableProxy: true,
		proxy: {
			host: '140.143.96.216',
			port: 80,
			protocol: 'http',
		},
	})
	.then(result => {
		let data = iconv.decode(result.data, 'gb2312');
		// console.log(result.res.statusCode, data.toString());
		let $ = cheerio.load(data);
		console.log($('body>table>tbody tr').slice(0, 2).eq(1)
			.text());
	})
	.catch(err => {
		console.error(err);
	});
