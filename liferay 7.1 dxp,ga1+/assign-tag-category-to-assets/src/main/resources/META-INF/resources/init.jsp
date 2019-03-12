<%@page import="java.util.Date"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@page import="com.liferay.document.library.kernel.model.DLFileEntry"%>
<%@page import="com.liferay.bookmarks.model.BookmarksEntry"%>
<%@page import="com.liferay.journal.model.JournalArticle"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.kernel.dao.orm.DynamicQuery"%>
<%@page import="com.liferay.asset.kernel.model.AssetEntry"%>
<%@page import="com.liferay.message.boards.kernel.model.MBThread"%>
<%@page import="com.liferay.wiki.model.WikiPage"%>
<%@page import="javax.portlet.RenderResponse"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil"%>
<%@page import="com.liferay.asset.kernel.service.AssetEntryLocalServiceUtil"%>

<%@ taglib uri="http://liferay.com/tld/asset" prefix="liferay-asset" %>
<%@ taglib uri="http://liferay.com/tld/clay" prefix="clay" %>
<%@ taglib uri="http://liferay.com/tld/ddm" prefix="liferay-ddm" %>
<%@ taglib uri="http://liferay.com/tld/expando" prefix="liferay-expando" %>
<%@ taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %>
<%@ taglib uri="http://liferay.com/tld/security" prefix="liferay-security" %>
<%@ taglib uri="http://liferay.com/tld/soy" prefix="soy" %>
<%@ taglib uri="http://liferay.com/tld/trash" prefix="liferay-trash" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<c:set var="now" value="<%=new Date()%>"/>
<fmt:formatDate var="temp" pattern="s" type = "time"  value = "${now}" />

   <!-- common.js -->
<script src="<%=request.getContextPath()%>/js/common.js?${temp}"></script>

<liferay-frontend:defineObjects />
<liferay-theme:defineObjects />
<liferay-trash:defineObjects />
<portlet:defineObjects />