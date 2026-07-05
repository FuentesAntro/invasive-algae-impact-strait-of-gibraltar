-- Create relational schema for mixed-methods ethnographic data
CREATE TABLE ports (
    port_id INT PRIMARY KEY,
    port_name VARCHAR(50),
    province VARCHAR(50)
);

CREATE TABLE interviews (
    interview_id INT PRIMARY KEY,
    port_id INT,
    fisherman_experience_years INT,
    FOREIGN KEY (port_id) REFERENCES ports(port_id)
);

CREATE TABLE qualitative_citations (
    citation_id INT PRIMARY KEY,
    interview_id INT,
    code_category VARCHAR(100), -- e.g., 'Invasive Algae', 'Fishing Grounds Collapse'
    citation_text TEXT,
    sentiment_score INT, -- Scale -2 to +2
    FOREIGN KEY (interview_id) REFERENCES interviews(interview_id)
);

-- Query example: Identify top conflict drivers and average sentiment by port
SELECT 
    p.port_name,
    qc.code_category,
    COUNT(qc.citation_id) AS total_mentions,
    AVG(qc.sentiment_score) AS avg_sentiment
FROM qualitative_citations qc
JOIN interviews i ON qc.interview_id = i.interview_id
JOIN ports p ON i.port_id = p.port_id
GROUP BY p.port_name, qc.code_category
HAVING COUNT(qc.citation_id) > 5
ORDER BY total_mentions DESC;
