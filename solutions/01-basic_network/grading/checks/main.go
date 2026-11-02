package main

import "gitlab.com/hei-tools/grader"

// Run from solutions/<X>/grading (see the grader README):
//
//	go run ./checks -config ../../../../admin/<year>/grading.yaml check|init-judgments|link|render|verify|review|migrate-names
//	go run ./checks spec-md grading.yaml
func main() { grader.Main(Exercise, checks) }
