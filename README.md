# industrial-air-quality-platform-mvp


Industrial Air Quality Analytics Platform

A serverless AWS project demonstrating event-driven data ingestion,
analytics, alerting and Infrastructure as Code using Terraform.

## Executive Summary 
This project demonstrates how a cloud-native serverless architecture can collect, process and analyze environmental data using AWS managed services.

The platform periodically collects PSI readings from Singapore's NEA Open Data API, stores raw data in Amazon S3, converts it into Parquet format for efficient analytics using Amazon Athena, and sends notifications when air quality crosses configurable thresholds.

The infrastructure is provisioned entirely using Terraform and can be deployed within minutes.
