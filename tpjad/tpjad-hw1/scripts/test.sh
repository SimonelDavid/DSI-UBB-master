#!/bin/bash

NAMESPACE="tpjad-hw1"

# Checking namespace
if ! kubectl get namespace $NAMESPACE >/dev/null 2>&1; then
  echo "❌ Namespace $NAMESPACE nu există. Creează-l înainte de a rula scriptul."
  exit 1
fi

# Chcking pods
echo "🔍 Checking pod statuses..."
kubectl get pods -n $NAMESPACE

# Testing WildFly
echo "🌐 Testing WildFly direct response..."
TOMCAT_POD=$(kubectl get pods -n $NAMESPACE -l app=tomcat -o jsonpath="{.items[0].metadata.name}")

if [ -z "$TOMCAT_POD" ]; then
  echo "❌ No Tomcat pod found in namespace $NAMESPACE. Exiting."
  exit 1
fi

TOMCAT_TO_WILDFLY_RESPONSE=$(kubectl exec -n $NAMESPACE $TOMCAT_POD -- curl -s http://wildfly-service.tpjad-hw1.svc.cluster.local:8081/servlet-wildfly-1.0-SNAPSHOT/wildfly)

if [ -z "$TOMCAT_TO_WILDFLY_RESPONSE" ]; then
  echo "❌ No response received from WildFly. Check the WildFly pod or service."
else
  echo "✅ Response from WildFly: $TOMCAT_TO_WILDFLY_RESPONSE"
fi

# Testing Tomcat → WildFly communication
echo "🌐 Testing communication from WildFly to Tomcat..."
JETTY_POD=$(kubectl get pods -n $NAMESPACE -l app=jetty -o jsonpath="{.items[0].metadata.name}")

if [ -z "$JETTY_POD" ]; then
  echo "❌ No Jetty pod found in namespace $NAMESPACE. Exiting."
  exit 1
fi

WILDFLY_TO_TOMCAT_RESPONSE=$(kubectl exec -n $NAMESPACE $JETTY_POD -- curl -s http://tomcat-service.tpjad-hw1.svc.cluster.local:8080/servlet-tomcat/tomcat)

if [ -z "$WILDFLY_TO_TOMCAT_RESPONSE" ]; then
  echo "❌ No response received from Tomcat. Check the Tomcat pod or service."
else
  echo "✅ Response from WildFly (via Tomcat): $WILDFLY_TO_TOMCAT_RESPONSE"
fi

# Testing Jetty → WildFly communication
echo "🌐 Testing communication from WildFly to Jetty via Tomcat..."
WILDFLY_TO_JETTY_RESPONSE=$(kubectl exec -n $NAMESPACE $TOMCAT_POD -- curl -s http://jetty-service.tpjad-hw1.svc.cluster.local:8082/servlet-jetty/jetty)

if [ -z "$WILDFLY_TO_JETTY_RESPONSE" ]; then
  echo "❌ No response received from Jetty. Check the Jetty pod or service."
else
  echo "✅ Response from WildFly (via Jetty and Tomcat): $WILDFLY_TO_JETTY_RESPONSE"
fi

echo "🎉 All tests completed."