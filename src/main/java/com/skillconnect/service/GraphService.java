package com.skillconnect.service;

import org.neo4j.driver.Driver;
import org.neo4j.driver.Record;
import org.neo4j.driver.Session;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class GraphService {

    private final Driver driver;

    public GraphService(Driver driver) {
        this.driver = driver;
    }

    // Developer skills
    public List<String> developerSkills(String name) {

        try (Session session = driver.session()) {

            return session.run(
                    "MATCH (d:Developer {name: $name})-[:HAS_SKILL]->(s:Skill) " +
                    "RETURN s.name AS skill ORDER BY skill",
                    Map.of("name", name)
            ).list(record -> record.get("skill").asString());
        }
    }

    // Job matching
    public List<Map<String, Object>> matchJobs(List<String> skills) {

        try (Session session = driver.session()) {

            return session.run(
                    "MATCH (j:Job)-[:REQUIRES]->(s:Skill) " +
                    "WHERE s.name IN $skills " +
                    "WITH j, collect(s.name) AS matchedSkills " +
                    "RETURN j.id AS id, " +
                    "j.title AS title, " +
                    "j.company AS company, " +
                    "matchedSkills, " +
                    "size(matchedSkills) AS score " +
                    "ORDER BY score DESC",
                    Map.of("skills", skills)
            ).list(record -> Map.of(
                    "id", record.get("id").asInt(),
                    "title", record.get("title").asString(),
                    "company", record.get("company").asString(),
                    "matchedSkills",
                    record.get("matchedSkills")
                            .asList(value -> value.asString()),
                    "score", record.get("score").asInt()
            ));
        }
    }

    // Multi-hop related developers
    public List<Map<String, Object>> relatedDevelopers(String name) {

        try (Session session = driver.session()) {

            return session.run(
                    "MATCH (d:Developer {name: $name}) " +
                    "-[:WORKED_ON]->(:Project)-[:USES]->(t:Technology) " +
                    "<-[:USES]-(:Project)<-[:WORKED_ON]-(other:Developer) " +
                    "WHERE other <> d " +
                    "RETURN DISTINCT other.name AS developer, " +
                    "collect(DISTINCT t.name) AS sharedTechnologies " +
                    "ORDER BY developer",
                    Map.of("name", name)
            ).list(record -> Map.of(
                    "developer",
                    record.get("developer").asString(),
                    "sharedTechnologies",
                    record.get("sharedTechnologies")
                            .asList(value -> value.asString())
            ));
        }
    }

    // Related skills
    public List<String> relatedSkills(String skill) {

        try (Session session = driver.session()) {

            return session.run(
                    "MATCH (s:Skill {name: $skill})" +
                    "-[:RELATED_TO]->(related:Skill) " +
                    "RETURN related.name AS relatedSkill " +
                    "ORDER BY relatedSkill",
                    Map.of("skill", skill)
            ).list(record ->
                    record.get("relatedSkill").asString()
            );
        }
    }
}