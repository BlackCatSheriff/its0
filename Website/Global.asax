﻿<%@ Application Language="C#" %>

<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    
    void Application_Start(object sender, EventArgs e) 
    {
        // 在应用程序启动时运行的代码
        
        // 初始化异常日志队列
        _.ExceptionLogQueue = new System.Collections.Concurrent.ConcurrentQueue<Exception>();

        // 访问异常日志的快捷方式
        RouteTable.Routes.Add("ExceptionLog", new Route("ex",
            new PageRouteHandler("~/ExceptionLog.aspx")));
        RouteTable.Routes.Add("ExceptionLog2", new Route("ex.aspx",
            new PageRouteHandler("~/ExceptionLog.aspx")));
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  在应用程序关闭时运行的代码

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // 在出现未处理的错误时运行的代码

        // 发生错误时的 URL，注意 Request 不可用时会引发异常
        var url = "";
        try
        {
            url = HttpContext.Current.Request.RawUrl;
        }
        catch
        {
        }
        
        // 记录异常
        var ex = Server.GetLastError().GetBaseException();
        if (ex.GetType() != typeof(System.Threading.ThreadAbortException) && // 忽略强制终止线程
            url != "/favicon.ico") // 忽略图标不存在
        {
            ex.Data["__its_exception_occur_time__"] = DateTime.Now;
            ex.Data["__its_exception_url__"] = url;
            
            _.ExceptionLogQueue.Enqueue(ex);
        }
    }

    void Session_Start(object sender, EventArgs e) 
    {
        // 在新会话启动时运行的代码

    }

    void Session_End(object sender, EventArgs e) 
    {
        // 在会话结束时运行的代码。 
        // 注意: 只有在 Web.config 文件中的 sessionstate 模式设置为
        // InProc 时，才会引发 Session_End 事件。如果会话模式设置为 StateServer
        // 或 SQLServer，则不引发该事件。

    }
       
</script>
