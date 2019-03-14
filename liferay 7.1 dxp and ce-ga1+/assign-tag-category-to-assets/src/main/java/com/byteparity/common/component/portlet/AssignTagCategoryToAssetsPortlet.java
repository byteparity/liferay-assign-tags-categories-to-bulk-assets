package com.byteparity.common.component.portlet;

import com.byteparity.common.component.constants.AssignTagCategoryToAssetsPortletKeys;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

import javax.portlet.Portlet;

import org.osgi.service.component.annotations.Component;

/**
 * @author baps
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=GA1",
		"com.liferay.portlet.instanceable=false",
		"javax.portlet.display-name=assign-tag-category-to-assets Portlet",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + AssignTagCategoryToAssetsPortletKeys.AssignTagCategoryToAssets,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class AssignTagCategoryToAssetsPortlet extends MVCPortlet {
	
}