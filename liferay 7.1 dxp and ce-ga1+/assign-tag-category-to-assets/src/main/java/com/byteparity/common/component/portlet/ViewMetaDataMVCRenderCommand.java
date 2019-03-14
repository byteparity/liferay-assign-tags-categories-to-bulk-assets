package com.byteparity.common.component.portlet;

import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;

import com.byteparity.common.component.constants.AssignTagCategoryToAssetsPortletKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCRenderCommand;


@Component(
		 property = {
		 "javax.portlet.name="+AssignTagCategoryToAssetsPortletKeys.AssignTagCategoryToAssets,
		 "mvc.command.name=/assign_metadata"
		 }, service = MVCRenderCommand.class)
public class ViewMetaDataMVCRenderCommand implements MVCRenderCommand {

	private static final String VIEW_METADATA = "/assign_metadata.jsp";
	
	@Override
	public String render(RenderRequest renderRequest, RenderResponse renderResponse) throws PortletException {
		return VIEW_METADATA;
	}

}
