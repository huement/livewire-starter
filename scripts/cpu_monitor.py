import psutil
import time
import logging
import os

# Get the parent directory (repo root) and create logs directory there
script_dir = os.path.dirname(os.path.abspath(__file__))
# Go up one level from scripts/ to repo root
repo_root = os.path.dirname(script_dir)
logs_dir = os.path.join(repo_root, 'storage/logs')
if not os.path.exists(logs_dir):
    os.makedirs(logs_dir)

log_file = os.path.join(logs_dir, 'cpu_usage.log')
logging.basicConfig(filename=log_file, level=logging.INFO,
                    format='%(asctime)s - CPU Usage: %(message)s')


def check_cpu_bottleneck(threshold=90, duration=60, interval=1):
    print("Monitoring CPU usage...")
    start_time = time.time()

    while time.time() - start_time < duration:
        cpu_percent = psutil.cpu_percent(interval=interval)
        cpu_per_core = psutil.cpu_percent(percpu=True)
        load_avg = psutil.getloadavg()
        log_message = f"Overall CPU: {cpu_percent}% | Per-core: {cpu_per_core} | Load Avg: {load_avg}"
        logging.info(log_message)

        if cpu_percent > threshold:
            print(f"Warning: High CPU usage - {cpu_percent}%")

        time.sleep(interval)


if __name__ == "__main__":
    try:
        check_cpu_bottleneck(threshold=90, duration=60, interval=1)
    except KeyboardInterrupt:
        print("\nMonitoring stopped.")
