import Foundation
import Dispatch

func async1(completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        print("acyns1")
        completion()
    }
}

func async2(completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        print("acyns2")
        completion()
    }
}

// 並列処理
let group1 = DispatchGroup()
let queue1 = DispatchQueue(label: "queue")
queue1.async(group: group1) {
    print("start")
    
    group1.enter()
    async1 {
        print("finish async1")
        group1.leave()
    }
    
    group1.enter()
    async1 {
        print("finish async1")
        group1.leave()
    }
}

group1.notify(queue: .main) {
    print("finish all")
}

// 直列
let semaphore = DispatchSemaphore(value: 0)
let group2 = DispatchGroup()
let queue2 = DispatchQueue(label: "queue2")
queue2.async(group: group2) {
    group2.enter()
    async1 {
        print("finish async1")
        group2.leave()
        semaphore.signal()
    }
    semaphore.wait()
    
    async2 {
        print("finish async2")
        group2.leave()
        semaphore.signal()
    }
    semaphore.wait()
}

group2.notify(queue: .main) {
    print("finish all")
}
