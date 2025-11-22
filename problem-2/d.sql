SELECT 
    f.rfam_acc,
    f.rfam_id AS family_name,
    MAX(rf.length) AS max_length
FROM family f
JOIN full_region fr ON f.rfam_acc = fr.rfam_acc
JOIN rfamseq rf ON fr.rfamseq_acc = rf.rfamseq_acc
GROUP BY f.rfam_acc, f.rfam_id
HAVING MAX(rf.length) > 1000000
ORDER BY max_length DESC
LIMIT 15 OFFSET 120;