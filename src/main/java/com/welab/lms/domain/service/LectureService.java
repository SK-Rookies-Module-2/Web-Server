package com.welab.lms.domain.service;

import com.welab.lms.persistence.repository.BoardRepository;
import com.welab.lms.persistence.repository.LectureRepository;
import com.welab.lms.persistence.repository.StudyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class LectureService {
    @Autowired
    private LectureRepository lectureRepository;
    @Autowired
    private BoardRepository boardRepository;
    @Autowired
    private StudyRepository studyRepository;

    // 과정 평가 항목 및 점수 목록 전체 조회
    public List<Map<String, Object>> getEvaluations() {
        return lectureRepository.findAllEvaluations();
    }

    // 등록된 모든 스터디 그룹 목록 조회
    public List<Map<String, Object>> getStudyGroups() {
        return studyRepository.findAllStudyGroups();
    }

    // 사용자 아이디를 기반으로 공지사항 목록 조회 [취약점: 파라미터 변조를 통한 관리자 권한 도용 및 인가 우회 가능]
    public List<Map<String, Object>> getNotices(String userId) {
        // [취약점: 단순히 문자열 비교만으로 관리자 여부를 판단하여 세션/토큰 검증 부재]
        boolean isAdmin = "admin".equals(userId);
        return boardRepository.findAllNoticesVulnerable(isAdmin);
    }
}