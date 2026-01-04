package com.welab.lms.web.controller;

import com.welab.lms.domain.service.ExplorerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import javax.servlet.http.HttpServletRequest;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@RestController
public class VulnerableExplorerController {

    @Autowired
    private ExplorerService explorerService;

    @GetMapping("/root/**")
    public String explore(HttpServletRequest request) throws Exception { // 에러를 밖으로 던집니다
        String uri = request.getRequestURI();
        // try-catch 블록을 아예 삭제하여 에러가 그대로 브라우저까지 전달되게 합니다
        String pathInSystem = URLDecoder.decode(
                uri.replace("/root", ""),
                StandardCharsets.UTF_8.toString());

        return explorerService.explorePath(pathInSystem);
    }
}