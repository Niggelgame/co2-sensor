package dbcleanup

type DbCleanup interface {
	Cleanup()

	StopCleanup()
}
