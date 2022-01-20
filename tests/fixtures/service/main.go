package main

import (
	"io/ioutil"
	"os"
	"time"

	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	easy "github.com/t-tomalak/logrus-easy-formatter"
)

var (
	debugVar bool
	traceVar bool
	quietVar bool
	rootCmd  = &cobra.Command{
		Use:   "test-service",
		Short: "test service",
		Run:   run,
	}
)

func main() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func run(cmd *cobra.Command, args []string) {
	logrus.Debugf("%+v", args)
	logrus.Print("starting test service\n")
	for {
		logrus.Print("ping\n")
		time.Sleep(5 * time.Second)
	}
}

func init() {
	cobra.OnInitialize(initConfig)
	rootCmd.PersistentFlags().BoolVarP(&debugVar, "debug", "d", false, "Turn on debug verbosity")
	rootCmd.PersistentFlags().BoolVarP(&traceVar, "trace", "t", false, "Turn on trace verbosity")
	rootCmd.PersistentFlags().BoolVarP(&quietVar, "quiet", "q", false, "Turn off all output.")
}

func initConfig() {
	if debugVar || traceVar {
		if debugVar {
			logrus.SetLevel(logrus.DebugLevel)
		}
		if traceVar {
			logrus.SetLevel(logrus.TraceLevel)
		}
	} else {
		logrus.SetFormatter(&easy.Formatter{
			LogFormat: "%msg%",
		})
	}

	if quietVar {
		logrus.SetOutput(ioutil.Discard)
	}
}
