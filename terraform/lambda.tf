data "archive_file" "collector_zip" {
  type        = "zip"
  source_dir  = "../lambdas/collector"
  output_path = "../lambdas/collector.zip"
}
