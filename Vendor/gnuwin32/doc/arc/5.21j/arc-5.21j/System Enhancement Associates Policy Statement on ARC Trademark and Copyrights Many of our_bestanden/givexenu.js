function givecookie(name, value) {
 stTheDate = new Date()
 stExpireDate = new Date()
 stExpireDate.setTime(stTheDate.getTime() + 60*60*24*365*1000)
 document.cookie = name + "=" + escape(value) + " " +
   escape(stTheDate) + "; expires=" + stExpireDate.toGMTString()
}
