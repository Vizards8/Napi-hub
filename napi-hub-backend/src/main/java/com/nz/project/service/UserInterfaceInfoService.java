package com.nz.project.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.nz.napicommon.model.entity.UserInterfaceInfo;

/**
 * @author Vizar
 * @description 针对表【user_interface_info(用户调用接口关系)】的数据库操作Service
 * @createDate 2023-06-04 23:28:37
 */
public interface UserInterfaceInfoService extends IService<UserInterfaceInfo> {


    void validUserInterfaceInfo(UserInterfaceInfo userInterfaceInfo, boolean add);

    /**
     * 调用接口统计
     *
     * @param interfaceInfoId
     * @param userId
     * @return
     */
    boolean invokeCount(long interfaceInfoId, long userId);
}
