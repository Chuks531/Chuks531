## Hi there 👋 🚀

<!--
**Chuks531/Chuks531** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.

Here are some ideas to get you started:

- 🔭 I’m currently working on ...building a robust system that would resolve the 3Vs challenges of a data engineer. 
- 🌱 I’m currently learning ... I am currently enhancing my skills more in data engineering using the SSIS service for integration and performing ETL.
- 👯 I’m looking to collaborate on ... Massive projects from the commencement stage of data sources to the final stage of data rest.
- 🤔 I’m looking for help with ... Anyone coonnect to getting my hands dirty in data pipelines for data engineering
- 💬 Ask me about ... I am a data enthusiast and passionable in resolving complex issues and building systems to help with data movement and data consistency
- 📫 How to reach me: ... LinkedIn (https://www.linkedin.com/in/chukwuka-okoli-63192425b/), Email: okolichukwukanz@gmail.com, Mobile Contact: +2348030764766
- 😄 Pronouns: ... His
- ⚡ Fun fact: ... Love Resaerching and Discovering new things, meeting people, travelling, Soccer games and Playing Tennis.
-->

JSON code for permission creation and allowing or denying a service principal access to the Resources:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "KmsActionsIfCalledViaChain",
            "Effect": "Allow",
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey",
                "kms:DescribeKey"
            ],
            "Resource": "arn:aws:kms:region:111122223333:key/my-example-key",
            "Condition": {
                "StringEquals": {
                    "aws:CalledViaFirst": "cloudformation.amazonaws.com",
                    "aws:CalledViaLast": "dynamodb.amazonaws.com"
                }
            }
        }
    ]
}
