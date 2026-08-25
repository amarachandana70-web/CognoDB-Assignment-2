package com.skillconnect.controller;

import com.skillconnect.service.GraphService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class GraphController {

    private final GraphService graphService;

    public GraphController(GraphService graphService) {
        this.graphService = graphService;
    }

    // Developer skills
    @GetMapping("/developers/{name}/skills")
    public ResponseEntity<?> getDeveloperSkills(
            @PathVariable String name) {

        try {
            return ResponseEntity.ok(
                    graphService.developerSkills(name)
            );
        } catch (Exception e) {
            return databaseError();
        }
    }

    // Job matching
    @PostMapping("/jobs/match")
    public ResponseEntity<?> matchJobs(
            @RequestBody Map<String, Object> request) {

        Object skillsObject = request.get("skills");

        if (!(skillsObject instanceof List<?>)) {
            return ResponseEntity.badRequest()
                    .body(Map.of(
                            "error",
                            "Please provide a skills list."
                    ));
        }

        List<?> rawSkills = (List<?>) skillsObject;

        if (rawSkills.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of(
                            "error",
                            "Please select at least one skill."
                    ));
        }

        List<String> skills = rawSkills.stream()
                .map(Object::toString)
                .toList();

        try {
            return ResponseEntity.ok(
                    graphService.matchJobs(skills)
            );
        } catch (Exception e) {
            return databaseError();
        }
    }

    // Related developers
    @GetMapping("/developers/{name}/related")
    public ResponseEntity<?> getRelatedDevelopers(
            @PathVariable String name) {

        try {
            return ResponseEntity.ok(
                    graphService.relatedDevelopers(name)
            );
        } catch (Exception e) {
            return databaseError();
        }
    }

    // Related skills
    @GetMapping("/skills/{skill}/related")
    public ResponseEntity<?> getRelatedSkills(
            @PathVariable String skill) {

        try {
            return ResponseEntity.ok(
                    graphService.relatedSkills(skill)
            );
        } catch (Exception e) {
            return databaseError();
        }
    }

    private ResponseEntity<Map<String, String>> databaseError() {
        return ResponseEntity.internalServerError()
                .body(Map.of(
                        "error",
                        "Database unavailable. Please try again."
                ));
    }
}